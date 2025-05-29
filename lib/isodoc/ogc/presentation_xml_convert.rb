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
          <annex #{add_id_text} obligation='informative'>
          <title #{add_id_text}>#{@i18n.dochistory}</title>
          <table unnumbered="true" #{add_id_text}><thead>
          <tr #{add_id_text}><th #{add_id_text}>Date</th><th #{add_id_text}>Release</th><th #{add_id_text}>Author</th>
            <th #{add_id_text}>Paragraph Modified</th><th #{add_id_text}>Description</th></tr>
          </thead><tbody>#{ret}</tbody></table></annex>
        XML
      end

      def generate_dochistory_row(item)
        e = item.at(ns("./edition")) || item.at(ns("./version/draft"))
        date = dochistory_date(item)
        c = dochistory_contributors(item)
        l = dochistory_location(item)
        desc = dochistory_description(item)
        <<~XML
          <tr #{add_id_text}><td #{add_id_text}>#{date}</td><td #{add_id_text}>#{e&.text}</td><td #{add_id_text}>#{c}</td>
            <td #{add_id_text}>#{l}</td><td #{add_id_text}>#{desc}</td></tr>
        XML
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

      def termsource_label(elem, sources)
        elem.replace(l10n("[<strong>#{@i18n.source}:</strong> " \
                             "#{sources}]"))
      end

      def bibliography_bibitem_number_skip(bibitem)
        implicit_reference(bibitem) ||
          bibitem.at(ns(".//docidentifier[@type = 'metanorma-ordinal']")) ||
          bibitem["hidden"] == "true" || bibitem.parent["hidden"] == "true"
      end

      def bibrender_formattedref(formattedref, xml); end

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
        elem.xpath(ns(".//semx[@element = 'deprecates']")).each do |s|
          s.next = "&#xa0;<span class='DeprecatedLabel'>#{@i18n.deprecated}</span>"
        end
      end

      def admits(elem)
        elem.xpath(ns(".//semx[@element = 'admitted']")).each do |s|
          s.next = "&#xa0;<span class='AdmittedLabel'>#{@i18n.admitted}</span>"
        end
      end

      # def designation_boldface(desgn); end

      def source_label(elem)
        labelled_ancestor(elem) and return
        n = @xrefs.get[elem["id"]]
        lbl = labelled_autonum(lower2cap(@i18n.sourcecode), elem["id"],
                               n&.dig(:label))
        prefix_name(elem, { caption: block_delim }, lbl, "name")
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

      def ul_label_list(_elem)
        if @doctype == "white-paper" then %w(&#x2014;)
        else %w(&#x2022;)
        end
      end

      def ol_label_template(_elem)
        super
          .merge({
                   alphabet_upper: %{%<span class="fmt-label-delim">)</span>},
                   arabic: %{%<span class="fmt-label-delim">.</span>},
                 })
      end

      include Init
    end
  end
end
