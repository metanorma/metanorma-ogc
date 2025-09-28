module Metanorma
  module Ogc
    class Converter < Standoc::Converter
      # ignore, we generate ToC outside of asciidoctor
      def toc(value); end

      def sectiontype(node, level = true)
        ret = sectiontype_streamline(sectiontype1(node))
        return ret if ret == "terms and definitions" &&
          node.attr("style") == "appendix" && node.level == 1

        super
      end

      def section(node)
        override_style(node)
        super
      end

      def override_style(node)
        s = node.attr("style")
        if %w(overview future_outlook value_proposition
              contributors).include?(s)
          node.set_attr("style", "preface")
          node.set_attr("type", s)
        end
        if %w(aims objectives topics outlook security).include?(s)
          node.set_attr("type", s)
        end
      end

      def sectiontype_streamline(ret)
        case ret
        when "preface" then "foreword"
        when "foreword", "introduction" then "donotrecognise-foreword"
        when "references" then "normative references"
        when "glossary" then "terms and definitions"
        else super
        end
      end

      # legacy encoding
      def sectiontype1(node)
        role_style(node, "executive_summary") and return "executivesummary"
        super
      end

      def clause_parse(attrs, xml, node)
        %w(overview future_outlook value_proposition
           contributors aims objectives topics outlook security)
          .include?(node.attr("type")) and
          attrs = attrs.merge(type: node.attr("type"))
        case node.attr("heading")&.downcase || node.title.downcase
        when "submitters"
          return submitters_parse(attrs.merge(type: "submitters"), xml, node)
        when "contributors"
          return submitters_parse(attrs.merge(type: "contributors"), xml, node)
        when "conformance" then attrs = attrs.merge(type: "conformance")
        when "security considerations"
          attrs = attrs.merge(type: "security")
        end
        super
      end

      def submitters_parse(attrs, xml, node)
        title = @i18n.submitters
        doctype(node) == "engineering-report" ||
          attrs[:type] == "contributors" and
          title = @i18n.contributors_clause
        xml.clause **attr_code(attrs) do |xml_section|
          section_title(xml_section, title)
          xml_section << node.content
        end
      end

      def term_def_parse(attrs, xml, node, _toplevel)
        if node.attr("style") == "appendix" && node.level == 1
          terms_annex_parse(attrs, xml, node)
        else
          super
        end
      end

      def terms_annex_parse(attrs, xml, node)
        attrs1 = attrs.merge(id: "_#{UUIDTools::UUID.random_create}")
        xml.annex **attr_code(attrs1) do |xml_section|
          section_title(xml_section, node.title)
          attrs.delete(:anchor)
          xml_section.terms **attr_code(attrs) do |terms|
            (s = node.attr("source")) && s.split(",").each do |s1|
              terms.termdocsource(nil, **attr_code(bibitemid: s1))
            end
            terms << node.content
          end
        end
      end

      def set_obligation(attrs, node)
        if node.attr("style") == "appendix" && node.level == 1
          attrs[:obligation] = if node.attributes.has_key?("obligation")
                                 node.attr("obligation")
                               else "informative"
                               end
        else
          super
        end
      end
    end
  end
end
