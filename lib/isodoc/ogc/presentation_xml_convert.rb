require_relative "init"
require_relative "../../relaton/render/general"
require_relative "presentation_sections"

module IsoDoc
  module Ogc
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def convert1(docxml, filename, dir)
        info docxml, nil
        unnumber_biblio(docxml)
        super
      end

      def rouge_css_location
        File.read(File.join(@libdir, "html", "rouge.css"))
      end

      # KILL
      def example1x(elem)
        lbl = @xrefs.anchor(elem["id"], :label, false)
        prefix_name(elem, block_delim, l10n("#{@i18n.example} #{lbl}"),
                    "name")
      end

      def bibdata(docxml)
        docxml.xpath(ns("//bibdata/contributor[@type = 'author']")).each do |a|
          a.at(ns("./description"))&.text == "contributor" and
            a["type"] = "contributor"
        end
        super
        dochistory_insert(docxml)
      end

      UPDATE_RELATIONS = <<~XPATH.freeze
        //bibdata/relation[@type = 'updatedBy' or @type = 'merges' or @type = 'splits' or @type = 'hasDraft']/bibitem
      XPATH

      def dochistory_insert(docxml)
        updates = docxml.xpath(ns(UPDATE_RELATIONS))
        updates.empty? and return
        fwd = annex_insert_point(docxml)
        generate_dochistory(updates, fwd)
      end

      def annex_insert_point(docxml)
        docxml.at(ns("//annex[last()]")) || docxml.at(ns("//sections"))
      end

      def generate_dochistory(updates, pref)
        ret = updates.map { |u| generate_dochistory_row(u) }.flatten.join("\n")
        pref.next = <<~XML
          <annex id='_#{UUIDTools::UUID.random_create}' obligation='informative'>
          <fmt-title>#{@i18n.dochistory}</fmt-title>
          <table><thead>
          <tr><th>Date</th><th>Release</th><th>Author</th><th>Paragraph Modified</th><th>Description</th></tr>
          </thead><tbody>
          #{ret}
          </tbody></table></annex>
        XML
      end

      def generate_dochistory_row(item)
        e = item.at(ns("./edition")) || item.at(ns("./version/draft"))
        date = dochistory_date(item)
        c = dochistory_contributors(item)
        l = dochistory_location(item)
        desc = dochistory_description(item)
        "<tr><td>#{date}</td><td>#{e&.text}</td><td>#{c}</td>" \
          "<td>#{l}</td><td>#{desc}</td></tr>"
      end

      def dochistory_date(item)
        d = item.at(ns("./date[@type = 'updated']")) ||
          item.at(ns("./date[@type = 'published']")) ||
          item.at(ns("./date[@type = 'issued']")) or return ""
        d.text.strip
      end

      def dochistory_contributors(item)
        item.xpath(ns("./contributor")).map do |c|
          dochistory_contributor(c)
        end.join(", ")
      end

      def dochistory_contributor(contrib)
        ret = contrib.at("./organization/subdivision") ||
          contrib.at("./organization/name") ||
          contrib.at("./person/name/abbreviation") ||
          contrib.at("./person/name/completename")
        ret and return ret.text
        format_personalname(contrib)
      end

      def format_personalname(contrib)
        Relaton::Render::Ogc::General
          .new(template: { book: "{{ creatornames }}" })
          .render("<bibitem type='book'>#{contrib.to_xml}</bibitem>",
                  embedded: true)
      end

      def dochistory_description(item)
        d = item.at(ns("./amend/description")) or return ""
        d.children.to_xml
      end

      def dochistory_location(item)
        t = item.at(ns("./amend/location")) or return "All"
        xpath = "./amend/location/locality | ./amend/location/localityStack"
        r = eref_localities(item.xpath(ns(xpath)), nil, t)
        r.sub!(/^, /, "")
        r == @i18n.wholeoftext and r = "All"
        r
      end

      def bibdata_i18n(bib)
        doctype = bib&.at(ns("./ext/doctype"))
        rename_stage(bib&.at(ns("./status/stage")), doctype, bib)
        rename_doctype(doctype, bib&.at(ns("./date[@type = 'published']")) ||
                       bib&.at(ns("./date[@type = 'issued']")))
        super
      end

      def rename_stage(stage, doctype, _bib)
        stage&.text == "approved" &&
          !%w(standard abstract-specification-topic draft-standard
              community-standard).include?(doctype&.text) and
          stage.children = "published"
      end

      def rename_doctype(doctype, date)
        (doctype&.text == "white-paper" && date) or return
        Date.iso8601(date.text) >= Date.iso8601("2021-12-16") and
          doctype.children = "technical-paper"
      end

      def ol_depth(node)
        node["class"] == "steps" ||
          node.at(".//ancestor::xmlns:ol[@class = 'steps']") or return super
        idx = node.xpath("./ancestor-or-self::xmlns:ol[@class = 'steps']").size
        %i(arabic alphabet roman alphabet_upper roman_upper)[(idx - 1) % 5]
      end

      def termsource1(elem)
        while elem&.next_element&.name == "termsource"
          elem << "; #{to_xml(elem.next_element.remove.children)}"
        end
        elem.children = l10n("[<strong>#{@i18n.source}:</strong> " \
                             "#{to_xml(elem.children).strip}]")
      end

      def bibliography_bibitem_number_skip(bibitem)
        implicit_reference(bibitem) ||
          bibitem.at(ns(".//docidentifier[@type = 'metanorma-ordinal']")) ||
          bibitem["hidden"] == "true" || bibitem.parent["hidden"] == "true"
      end

      def bibrender_formattedref(formattedref, xml); end

      def bibrender_relaton(xml, renderings)
        f = renderings[xml["id"]][:formattedref]
        f &&= "<formattedref>#{f}</formattedref>"
        keep = "./docidentifier | ./uri | ./note | ./status | ./biblio-tag"
        xml.children = "#{f}#{xml.xpath(ns(keep)).to_xml}"
      end

      def norm_ref_entry_code(_ordinal, _idents, _ids, _standard, _datefn, _bib)
        ""
      end

      # if ids is just a number, only use that ([1] Non-Standard)
      # else, use both ordinal, as prefix, and ids
      def biblio_ref_entry_code(ordinal, ids, _id, standard, datefn, _bib)
        standard and return "[#{ordinal}]<tab/>"
        ret = ids[:ordinal] || ids[:metanorma] || "[#{ordinal}]"
        prefix_bracketed_ref("#{ret}#{datefn}")
      end

      def deprecates(elem)
        elem << "&#xa0;<span class='DeprecatedLabel'>#{@i18n.deprecated}</span>"
      end

      def admits(elem)
        elem << "&#xa0;<span class='AdmittedLabel'>#{@i18n.admitted}</span>"
      end

      def source_label(elem)
        labelled_ancestor(elem) and return
        lbl = @xrefs.anchor(elem["id"], :label, false) or return
        prefix_name(elem, block_delim,
                    l10n("#{lower2cap @i18n.sourcecode} #{lbl}"), "name")
      end

      def references(docxml)
        unnumber_biblio(docxml)
        super
      end

      # prevent Eng Rept Biblio, which appears before Annexes, being numbered
      # needs to happen before xrefs first invoked
      def unnumber_biblio(docxml)
        @doctype == "engineering-report" or return
        b = docxml.at(ns(@xrefs.klass.bibliography_xpath)) or return
        b["unnumbered"] = true
      end

      def note_delim(_elem)
        ":<tab/>"
      end

      def reference_name(ref)
        super
        ogc_draft_ref?(ref) or return
        @xrefs.get[ref["id"]] =
          { xref: "#{@xrefs.get[ref['id']][:xref]} (draft)" }
      end

      def ogc_draft_ref?(ref)
        ref.at(ns("./docidentifier[@type = 'OGC']")) or return
        status = ref.at(ns("./status/stage"))&.text or return
        %w(approved published deprecated retired).include? status and return
        true
      end

      include Init
    end
  end
end
