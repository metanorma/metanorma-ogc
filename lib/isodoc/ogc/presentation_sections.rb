module IsoDoc
  module Ogc
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def middle_title(docxml); end

      def preface_rearrange(doc)
        super
        insert_preface_sections(doc)
      end

      def insert_preface_sections(doc)
        preface_insert(doc.at(ns("//preface/clause" \
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
        clause or return
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
        orgs.empty? and return
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
          <p>The following organizations submitted this Document to the Open Geospatial Consortium (OGC):</p>
           <ul>#{orgs.map { |m| "<li>#{m}</li>" }.join("\n")}</ul>
           </clause>
        SUBMITTING
      end

      def keyword_clause(kwords)
        <<~KEYWORDS
          <clause id="_#{UUIDTools::UUID.random_create}" type="keywords">
          <title>Keywords</fmt>
          <p>The following are keywords to be used by search engines and document catalogues.</p>
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

      def annex1(elem)
        lbl = @xrefs.anchor(elem["id"], :label)
        t = elem.at(ns("./title")) and
          t.children = "<strong>#{to_xml(t.children)}</strong>"
        prefix_name(elem, { caption: "<br/>" }, lbl, "title")
      end

      def clause(docxml)
        super
        docxml.xpath(ns("//submitters")).each { |f| clause1(f) }
      end

      def clause1(elem)
        elem.name == "terms" && elem.parent.name == "annex" &&
          elem.parent.xpath(ns("./terms")).size == 1 and return
        elem.name == "clause" && elem["type"] == "toc" and return
        super
      end
    end
  end
end
