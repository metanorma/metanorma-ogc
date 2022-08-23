require_relative "init"
require "uuidtools"
require_relative "../../relaton/render/general"

module IsoDoc
  module Ogc
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def convert1(docxml, filename, dir)
        info docxml, nil
        insert_preface_sections(docxml)
        super
      end

      def insert_preface_sections(doc)
        preface_insert(doc.at(ns("//preface/clause"\
                                 "[@type = 'executivesummary']")),
                       doc.at(ns("//preface/abstract")), doc)
        preface_insert(doc.at(ns("//preface//submitters")),
                       submit_orgs_append_pt(doc), doc)
        insert_submitting_orgs(doc)
        preface_insert(doc.at(ns("//preface/clause[@type = 'security']")),
                       submit_orgs_append_pt(doc), doc)
        insert_keywords(doc)
      end

      def preface_init_insert_pt(docxml)
        docxml.at(ns("//preface")) ||
          docxml.at(ns("//sections"))
            .add_previous_sibling("<preface> </preface>").first
      end

      def preface_insert(clause, after, docxml)
        return unless clause

        clause.remove
        if after then after.next = clause
        else
          preface_init_insert_pt(docxml)&.children&.first
            &.add_previous_sibling(clause)
        end
      end

      def submit_orgs_append_pt(docxml)
        docxml.at(ns("//foreword")) ||
          docxml.at(ns("//preface/clause[@type = 'keywords']")) ||
          docxml.at(ns("//preface/clause[@type = 'executivesummary']")) ||
          docxml.at(ns("//preface/abstract"))
      end

      def insert_submitting_orgs(docxml)
        orgs = docxml.xpath(ns(submittingorgs_path))
          .each_with_object([]) { |org, m| m << org.text }
        return if orgs.empty?

        if a = submit_orgs_append_pt(docxml)
          a.next = submitting_orgs_clause(orgs)
        else
          preface_init_insert_pt(docxml)&.children&.first
            &.add_previous_sibling(submitting_orgs_clause(orgs))
        end
      end

      def submitting_orgs_clause(orgs)
        <<~SUBMITTING
          <clause id="_#{UUIDTools::UUID.random_create}" type="submitting_orgs">
          <title>Submitting Organizations</title>
          <p>The following organizations submitted this Document to the
             Open Geospatial Consortium (OGC):</p>
           <ul>#{orgs.map { |m| "<li>#{m}</li>" }.join("\n")}</ul>
           </clause>
        SUBMITTING
      end

      def keyword_clause(kwords)
        <<~KEYWORDS
          <clause id="_#{UUIDTools::UUID.random_create}" type="keywords">
          <title>Keywords</title>
          <p>The following are keywords to be used by search engines and
              document catalogues.</p>
          <p>#{kwords.join(', ')}</p></clause>
        KEYWORDS
      end

      def insert_keywords(docxml)
        kw = @meta.get[:keywords]
        kw.empty? and return
        if abstract =
             docxml.at(ns("//preface/clause[@type = 'executivesummary']")) ||
             docxml.at(ns("//preface/abstract"))
          abstract.next = keyword_clause(kw)
        else
          preface_init_insert_pt(docxml)&.children&.first
            &.add_previous_sibling(keyword_clause(kw))
        end
      end

      def example1(elem)
        lbl = @xrefs.anchor(elem["id"], :label, false) or return
        prefix_name(elem, block_delim, l10n("#{@i18n.example} #{lbl}"),
                    "name")
      end

      def annex1(elem)
        lbl = @xrefs.anchor(elem["id"], :label)
        t = elem.at(ns("./title")) and
          t.children = "<strong>#{t.children.to_xml}</strong>"
        prefix_name(elem, "<br/>", lbl, "title")
      end

      def clause(docxml)
        super
        docxml.xpath(ns("//foreword | //preface/abstract | "\
                        "//submitters | //introduction | //acknowledgements"))
          .each do |f|
          clause1(f)
        end
      end

      def clause1(elem)
        return if elem.name == "terms" && elem.parent.name == "annex" &&
          elem.parent.xpath(ns("./terms")).size == 1

        super
      end

      def section(docxml)
        super
        references(docxml)
      end

      def bibdata(docxml)
        docxml.xpath(ns("//bibdata/contributor[@type = 'author']")).each do |a|
          a.at(ns("./description"))&.text == "contributor" and
            a["type"] = "contributor"
        end
        super
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
          !%w(standard abstract-specification-topic
              community-standard).include?(doctype&.text) and
          stage.children = "published"
      end

      def rename_doctype(doctype, date)
        return unless doctype&.text == "white-paper" && date

        Date.iso8601(date.text) >= Date.iso8601("2021-12-16") and
          doctype.children = "technical-paper"
      end

      def ol_depth(node)
        return super unless node["class"] == "steps" ||
          node.at(".//ancestor::xmlns:ol[@class = 'steps']")

        idx = node.xpath("./ancestor-or-self::xmlns:ol[@class = 'steps']").size
        %i(arabic alphabet roman alphabet_upper roman_upper)[(idx - 1) % 5]
      end

      def termsource1(elem)
        while elem&.next_element&.name == "termsource"
          elem << "; #{elem.next_element.remove.children.to_xml}"
        end
        elem.children = l10n("[<strong>#{@i18n.source}:</strong> "\
                             "#{elem.children.to_xml.strip}]")
      end

      def bibliography_bibitem_number_skip(bibitem)
        @xrefs.klass.implicit_reference(bibitem) ||
          bibitem.at(ns(".//docidentifier[@type = 'metanorma-ordinal']")) ||
          bibitem["hidden"] == "true" || bibitem.parent["hidden"] == "true"
      end

      def bibrenderer
        ::Relaton::Render::Ogc::General.new(language: @lang)
      end

      def bibrender_formattedref(formattedref, xml); end

      def bibrender_relaton(xml, renderings)
        f = renderings[xml["id"]][:formattedref]
        f &&= "<formattedref>#{f}</formattedref>"
        keep = "./docidentifier | ./uri | ./note | ./status"
        xml.children = "#{f}#{xml.xpath(ns(keep)).to_xml}"
      end

      def display_order(docxml)
        i = 0
        i = display_order_xpath(docxml, "//preface/*", i)
        i = display_order_at(docxml, "//clause[@type = 'scope']", i)
        i = display_order_at(docxml, "//clause[@type = 'conformance']", i)
        i = display_order_at(docxml, @xrefs.klass.norm_ref_xpath, i)
        i = display_order_at(docxml, "//sections/terms | "\
                                     "//sections/clause[descendant::terms]", i)
        i = display_order_at(docxml, "//sections/definitions", i)
        i = display_order_xpath(docxml, @xrefs.klass.middle_clause(docxml), i)
        i = display_order_xpath(docxml, "//annex", i)
        i = display_order_xpath(docxml, @xrefs.klass.bibliography_xpath, i)
        display_order_xpath(docxml, "//indexsect", i)
      end

      include Init
    end
  end
end
