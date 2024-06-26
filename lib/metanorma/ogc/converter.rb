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
      XML_ROOT_TAG = "ogc-standard".freeze
      XML_NAMESPACE = "https://www.metanorma.org/ns/ogc".freeze

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
        case node.attr("heading")&.downcase || node.title.downcase
        when "submitters"
          return submitters_parse(attrs, xml, node)
        when "contributors"
          return submitters_parse(attrs.merge(type: "contributors"), xml, node)
        when "conformance" then attrs = attrs.merge(type: "conformance")
        when "security considerations"
          attrs = attrs.merge(type: "security")
        when "executive summary"
          attrs = attrs.merge(type: "executivesummary")
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
