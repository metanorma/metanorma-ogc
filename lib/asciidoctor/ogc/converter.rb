require "asciidoctor"
require "asciidoctor/standoc/converter"
require "fileutils"
require_relative "front"
require_relative "validate"
require_relative "cleanup"

module Asciidoctor
  module Ogc
    # A {Converter} implementation that generates RSD output, and a document
    # schema encapsulation of the document for validation
    #
    class Converter < Standoc::Converter
      XML_ROOT_TAG = "ogc-standard".freeze
      XML_NAMESPACE = "https://www.metanorma.org/ns/ogc".freeze

      register_for "ogc"

      # ignore, we generate ToC outside of asciidoctor
      def toc(value); end

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
                  test-suite}.include? d
          @warned_doctype or
            @log.add("Document Attributes", nil,
                     "'#{d}' is not a legal document type: reverting to 'standard'")
          @warned_doctype = true
          d = "standard"
        end
        d
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

      def validate(doc)
        content_validate(doc)
        schema_validate(formattedstr_strip(doc.dup),
                        File.join(File.dirname(__FILE__), "ogc.rng"))
      end

      def clause_parse(attrs, xml, node)
        case node&.attr("heading")&.downcase || node.title.downcase
        when "submitters" then return submitters_parse(attrs, xml, node)
        when "conformance" then attrs = attrs.merge(type: "conformance")
        when "security considerations" then attrs =
                                              attrs.merge(type: "security")
        end
        super
      end

      def submitters_parse(attrs, xml, node)
        xml.submitters **attr_code(attrs) do |xml_section|
          xml_section.title @i18n.submitters
          xml_section << node.content
        end
      end

      def style(_node, _text)
        nil
      end

      def termdef_boilerplate_cleanup(xmldoc); end

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

      def presentation_xml_converter(node)
        IsoDoc::Ogc::PresentationXMLConvert.new(html_extract_attributes(node))
      end

      def html_converter(node)
        IsoDoc::Ogc::HtmlConvert.new(html_extract_attributes(node))
      end

      def pdf_converter(node)
        return nil if node.attr("no-pdf")

        IsoDoc::Ogc::PdfConvert.new(html_extract_attributes(node))
      end

      def doc_converter(node)
        IsoDoc::Ogc::WordConvert.new(doc_extract_attributes(node))
      end
    end
  end
end
