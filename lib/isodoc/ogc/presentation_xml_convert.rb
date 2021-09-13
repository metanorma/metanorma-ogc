require_relative "init"
require_relative "reqt"
require "isodoc"
require "uuidtools"

module IsoDoc
  module Ogc
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def convert1(docxml, filename, dir)
        info docxml, nil
        insert_preface_sections(docxml)
        super
      end

      def insert_preface_sections(docxml)
        insert_keywords(docxml)
        insert_submitting_orgs(docxml)
        insert_security(docxml)
      end

      def preface_init_insert_pt(docxml)
        docxml.at(ns("//preface")) ||
          docxml.at(ns("//sections"))
            .add_previous_sibling("<preface> </preface>").first
      end

      def submit_orgs_append_pt(docxml)
        docxml.at(ns("//introduction")) ||
          docxml.at(ns("//foreword")) ||
          docxml.at(ns("//preface/clause[@type = 'keywords']")) ||
          docxml.at(ns("//preface/abstract"))
      end

      def insert_security(docxml)
        s = docxml&.at(ns("//preface/clause[@type = 'security']"))&.remove or
          return
        if a = submit_orgs_append_pt(docxml)
          a.next = s
        else
          preface_init_insert_pt(docxml)&.children&.first
            &.add_previous_sibling(s)
        end
      end

      def insert_submitting_orgs(docxml)
        orgs = docxml.xpath(ns(submittingorgs_path))
          .each_with_object([]) do |org, m|
          m << org.text
        end
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
        if abstract = docxml.at(ns("//preface/abstract"))
          abstract.next = keyword_clause(kw)
        else
          preface_init_insert_pt(docxml)&.children&.first
            &.add_previous_sibling(keyword_clause(kw))
        end
      end

      def example1(elem)
        lbl = @xrefs.anchor(elem["id"], :label, false) or return
        prefix_name(elem, "&nbsp;&mdash; ", l10n("#{@i18n.example} #{lbl}"),
                    "name")
      end

      def recommendation1(elem, _type)
        type = recommendation_class_label(elem)
        label = elem&.at(ns("./label"))&.text
        if inject_crossreference_reqt?(elem, label)
          n = @xrefs.anchor(@xrefs.reqtlabels[label], :xref, false)
          lbl = (n.nil? ? type : n)
          elem&.at(ns("./title"))&.remove # suppress from display if embedded
        else
          n = @xrefs.anchor(elem["id"], :label, false)
          lbl = (n.nil? ? type : l10n("#{type} #{n}"))
        end
        prefix_name(elem, "", lbl, "name")
      end

      # embedded reqts xref to top level reqts via label lookup
      def inject_crossreference_reqt?(node, label)
        !node.ancestors("requirement, recommendation, permission").empty? &&
          @xrefs.reqtlabels[label]
      end

      def recommendation_class_label(node)
        case node["type"]
        when "verification" then @i18n.get["#{node.name}test"]
        when "class" then @i18n.get["#{node.name}class"]
        when "abstracttest" then @i18n.get["abstracttest"]
        when "conformanceclass" then @i18n.get["conformanceclass"]
        else
          case node.name
          when "recommendation" then @i18n.recommendation
          when "requirement" then @i18n.requirement
          when "permission" then @i18n.permission
          end
        end
      end

      def annex1(elem)
        lbl = @xrefs.anchor(elem["id"], :label)
        if t = elem.at(ns("./title"))
          t.children = "<strong>#{t.children.to_xml}</strong>"
        end
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

      def block(docxml)
        super
        recommendation_to_table(docxml)
      end

      def section(docxml)
        super
        references(docxml)
      end

      def references(docxml)
        super
        docxml.xpath(ns("//bibitem/date")).each do |d|
          d.xpath(ns("./on | ./from | ./to")).each do |d1|
            d1.children = d1.text.sub(/^(\d\d\d\d).*$/, "\\1")
          end
        end
      end

      include Init
    end
  end
end
