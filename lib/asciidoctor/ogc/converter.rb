require "asciidoctor"
require "asciidoctor/standoc/converter"
require "fileutils"
require_relative "front"
require_relative "validate"

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
      def toc(value)
      end

      def makexml(node)
        @draft = node.attributes.has_key?("draft")
        super
      end

      def doctype(node)
        d = super
        d1 = ::IsoDoc::Ogc::DOCTYPE_ABBR.invert[d] and d = d1
        unless %w{abstract-specification-topic best-practice 
          change-request-supporting-document community-practice 
          community-standard discussion-paper engineering-report other policy 
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
        when "foreword" then "donotrecognise-foreword"
        when "introduction" then "donotrecognise-foreword"
        when "references" then "normative references"
        else
          super
        end
      end

      def outputs(node, ret)
        File.open(@filename + ".xml", "w:UTF-8") { |f| f.write(ret) }
        presentation_xml_converter(node).convert(@filename + ".xml")
        html_converter(node).convert(@filename + ".presentation.xml", nil, false, "#{@filename}.html")
        doc_converter(node).convert(@filename + ".presentation.xml", nil, false, "#{@filename}.doc")
        pdf_converter(node)&.convert(@filename + ".presentation.xml", nil, false, "#{@filename}.pdf")
      end

      def validate(doc)
        content_validate(doc)
        schema_validate(formattedstr_strip(doc.dup), File.join(File.dirname(__FILE__), "ogc.rng"))
      end

      def sections_cleanup(x)
        super
        x.xpath("//*[@inline-header]").each do |h|
          h.delete("inline-header")
        end
      end

      def make_preface(x, s)
        super
        insert_security(x, s)
        insert_submitters(x, s)
      end

      def add_id
        %(id="_#{UUIDTools::UUID.random_create}")
      end

      def insert_security(x, s)
        doctype = s&.at("//bibdata/ext/doctype")&.text
        description = %w(standard community-standard).include?(doctype) ? "standard" : "document"
        preface = s.at("//preface") || s.add_previous_sibling("<preface/>").first
        s = x&.at("//clause[@type = 'security']")&.remove ||
          "<clause type='security' #{add_id}>"\
          "<title>Security Considerations</title>"\
          "<p>#{@i18n.security_empty.sub(/%/, description)}</p></clause>"
        preface.add_child s
      end

      def insert_submitters(x, s)
        if x.at("//submitters")
          preface = s.at("//preface") || s.add_previous_sibling("<preface/>").first
          submitters = x.at("//submitters").remove
          preface.add_child submitters.remove
        end
      end

      def clause_parse(attrs, xml, node)
        case clausetype = node&.attr("heading")&.downcase || node.title.downcase
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

      def style(n, t)
        return
      end

      def termdef_boilerplate_cleanup(xmldoc)
      end

      def bibdata_cleanup(xmldoc)
        super
        a = xmldoc.at("//bibdata/status/stage")
        a.text == "published" and a.children = "approved"
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
