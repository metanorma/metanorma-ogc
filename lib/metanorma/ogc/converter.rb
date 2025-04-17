require "asciidoctor"
require "metanorma/standoc/converter"
require "fileutils"
require_relative "front"
require_relative "validate"
require_relative "cleanup"

module Metanorma
  module Ogc
    # A {Converter} implementation that generates RSD output, and a document
    # schema encapsulation of the document for validation
    #
    class Converter < Standoc::Converter
      #XML_ROOT_TAG = "ogc-standard".freeze
      #XML_NAMESPACE = "https://www.metanorma.org/ns/ogc".freeze

      register_for "ogc"

      def init_toc(node)
        super
        @tocfigures = true
        @toctables = true
        @tocrecommendations = true
      end

      # ignore, we generate ToC outside of asciidoctor
      def toc(value); end

      def default_requirement_model
        "ogc"
      end

      def boilerplate_file(_xmldoc)
        File.join(@libdir, "boilerplate.adoc")
      end

      def makexml(node)
        @draft = node.attributes.has_key?("draft")
        super
      end

      def doctype(node)
        d = super
        d1 = ::IsoDoc::Ogc::DOCTYPE_ABBR.invert[d] and d = d1
        unless %w{abstract-specification-topic best-practice other policy
                  change-request-supporting-document community-practice
                  community-standard discussion-paper engineering-report
                  reference-model release-notes standard user-guide white-paper
                  technical-paper test-suite draft-standard}.include? d
          @warned_doctype or
            @log.add("Document Attributes", nil,
                     "'#{d}' is not a legal document type: reverting to 'standard'")
          @warned_doctype = true
          d = @default_doctype
        end
        d
      end

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
        if %w(overview future_outlook value_proposition contributors).include?(s)
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
        else
          super
        end
      end

      # legacy encoding
      def sectiontype1(node)
        role_style(node, "executive_summary") and return "executivesummary"
        super
      end

      def outputs(node, ret)
        File.open("#{@filename}.xml", "w:UTF-8") { |f| f.write(ret) }
        presentation_xml_converter(node).convert("#{@filename}.xml")
        html_converter(node).convert("#{@filename}.presentation.xml", nil,
                                     false, "#{@filename}.html")
        doc_converter(node).convert("#{@filename}.presentation.xml", nil,
                                    false, "#{@filename}.doc")
        pdf_converter(node)&.convert("#{@filename}.presentation.xml", nil,
                                     false, "#{@filename}.pdf")
      end

      def clause_parse(attrs, xml, node)
        %w(overview future_outlook value_proposition
           contributors aims objectives topics outlook security)
          .include?(node.attr("type")) and
          attrs = attrs.merge(type: node.attr("type"))
        case node.attr("heading")&.downcase || node.title.downcase
        when "submitters"
          return submitters_parse(attrs, xml, node)
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
        xml.submitters **attr_code(attrs) do |xml_section|
          xml_section.title title
          xml_section << node.content
        end
      end

      def style(_node, _text)
        nil
      end

      def term_def_parse(attrs, xml, node, _toplevel)
        if node.attr("style") == "appendix" && node.level == 1
          terms_annex_parse(attrs, xml, node)
        else
          super
        end
      end

      def table_cell(node, xml_tr, tblsec)
        node.set_attr("valign", "middle")
        super
      end

      def terms_annex_parse(attrs, xml, node)
        attrs1 = attrs.merge(id: "_#{UUIDTools::UUID.random_create}")
        xml.annex **attr_code(attrs1) do |xml_section|
          xml_section.title { |name| name << node.title }
          xml_section.terms **attr_code(attrs) do |terms|
            (s = node.attr("source")) && s.split(",").each do |s1|
              terms.termdocsource(nil, **attr_code(bibitemid: s1))
            end
            terms << node.content
          end
        end
      end

      def highlight_parse(text, xml)
        xml.hi { |s| s << text }
      end

      def set_obligation(attrs, node)
        if node.attr("style") == "appendix" && node.level == 1
          attrs[:obligation] = if node.attributes.has_key?("obligation")
                                 node.attr("obligation")
                               else "informative"
                               end
        else super
        end
      end

      OGC_COLORS = {
        "text": "rgb(88, 89, 91)",
        "secondary-shade-1": "rgb(237, 193, 35)",
        "secondary-shade-2": "rgb(246, 223, 140)",
        "background-definition-term": "rgb(215, 243, 255)",
        "background-definition-description": "rgb(242, 251, 255)",
        "text-title": "rgb(33, 55, 92)",
        "background-page": "rgb(33, 55, 92)",
        "background-text-label-legacy": "rgb(33, 60, 107)",
        "background-term-preferred-label": "rgb(249, 235, 187)",
        "background-term-deprecated-label": "rgb(237, 237, 238)",
        "background-term-admitted-label": "rgb(223, 236, 249)",
        "background-table-header": "rgb(33, 55, 92)",
        "background-table-row-even": "rgb(252, 246, 222)",
        "background-table-row-odd": "rgb(254, 252, 245)",
        "admonition-note": "rgb(79, 129, 189)",
        "admonition-tip": "rgb(79, 129, 189)",
        "admonition-editor": "rgb(79, 129, 189)",
        "admonition-important": "rgb(79, 129, 189)",
        "admonition-warning": "rgb(79, 129, 189)",
        "admonition-caution": "rgb(79, 129, 189)",
        "admonition-todo": "rgb(79, 129, 189)",
        "admonition-safety-precaution": "rgb(79, 129, 189)",
      }.freeze

      def metadata_attrs(node)
        c = update_colors(node)
        ret = super
        c.keys.sort.each do |k|
          ret += "<presentation-metadata><name>color-#{k}</name>" \
            "<value>#{c[k]}</value></presentation-metadata>"
        end
        ret
      end

      def update_colors(node)
        c = OGC_COLORS.dup
        if document_scheme(node) == "2022"
          c[:"secondary-shade-1"] = "rgb(0, 177, 255)"
          c[:"secondary-shade-2"] = "rgb(0, 177, 255)"
        end
        if node.attr("doctype") == "white-paper"
          c[:"text-title"] = "rgb(68, 84, 106)"
          c[:"background-page"] = "rgb(68, 84, 106)"
        end
        c
      end

      def presentation_xml_converter(node)
        IsoDoc::Ogc::PresentationXMLConvert
          .new(html_extract_attributes(node)
          .merge(output_formats: ::Metanorma::Ogc::Processor.new.output_formats))
      end

      def html_converter(node)
        IsoDoc::Ogc::HtmlConvert.new(html_extract_attributes(node))
      end

      def pdf_converter(node)
        return nil if node.attr("no-pdf")

        IsoDoc::Ogc::PdfConvert.new(pdf_extract_attributes(node))
      end

      def doc_converter(node)
        IsoDoc::Ogc::WordConvert.new(doc_extract_attributes(node))
      end

      # preempt subdoctype warning
      def adoc2xml(text, flavour)
        Nokogiri::XML(text).root and return text
        c = Asciidoctor
          .convert("= X\nA\n:semantic-metadata-headless: true\n" \
                   ":novalid:\n:docsubtype: implementation\n" \
                   ":doctype: standard\n\n#{text}\n",
                   backend: flavour, header_footer: true)
        Nokogiri::XML(c).at("//xmlns:sections")
      end
    end
  end
end
