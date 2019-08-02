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

      register_for "ogc"

      # ignore, we generate ToC outside of asciidoctor
      def toc(value)
      end

      def makexml(node)
        result = ["<?xml version='1.0' encoding='UTF-8'?>\n<ogc-standard>"]
        @draft = node.attributes.has_key?("draft")
        result << noko { |ixml| front node, ixml }
        result << noko { |ixml| middle node, ixml }
        result << "</ogc-standard>"
        result = textcleanup(result)
        ret1 = cleanup(Nokogiri::XML(result))
        validate(ret1) unless @novalid
        ret1.root.add_namespace(nil, Metanorma::Ogc::DOCUMENT_NAMESPACE)
        ret1
      end

      def doctype(node)
        d = node.attr("doctype")
        unless %w{standard standard-with-suite abstract-specification
        community-standard profile best-practice 
        engineering-report discussion-paper reference-model user-guide
        policy guide amendment technical-corrigendum administrative}.include? d
          warn "#{d} is not a legal document type: reverting to 'standard'"
          d = "standard"
        end
        d
      end

      def document(node)
        init(node)
        ret1 = makexml(node)
        ret = ret1.to_xml(indent: 2)
        unless node.attr("nodoc") || !node.attr("docfile")
          filename = node.attr("docfile").gsub(/\.adoc/, ".xml").
            gsub(%r{^.*/}, "")
          File.open(filename, "w") { |f| f.write(ret) }
          html_converter(node).convert filename unless node.attr("nodoc")
          word_converter(node).convert filename unless node.attr("nodoc")
          pdf_converter(node).convert filename unless node.attr("nodoc")
        end
        @files_to_delete.each { |f| FileUtils.rm f }
        ret
      end

      def validate(doc)
        content_validate(doc)
        schema_validate(formattedstr_strip(doc.dup),
                        File.join(File.dirname(__FILE__), "ogc.rng"))
      end

      def sections_cleanup(x)
        super
        x.xpath("//*[@inline-header]").each do |h|
          h.delete("inline-header")
        end
      end

      def make_preface(x, s)
        super
        if x.at("//submitters")
          preface = s.at("//preface") || s.add_previous_sibling("<preface/>").first
          submitters = x.at("//submitters").remove
          preface.add_child submitters.remove
        end
      end

      def clause_parse(attrs, xml, node)
        clausetype = node&.attr("heading")&.downcase || node.title.downcase
        if clausetype == "submitters" then submitters_parse(attrs, xml, node)
        else
          super
        end
      end

      def bibliography_parse(attrs, xml, node)
        clausetype = node&.attr("heading")&.downcase || node.title.downcase
        if clausetype == "references" then norm_ref_parse(attrs, xml, node) 
        else
          super
        end
      end

      def submitters_parse(attrs, xml, node)
        xml.submitters **attr_code(attrs) do |xml_section|
          xml_section << node.content
        end
      end

      def example(node)
        return term_example(node) if in_terms?
        role = node.role || node.attr("style")
        return requirement(node, "recommendation") if role == "recommendation"
        return requirement(node, "requirement") if role == "requirement"
        return requirement(node, "permission") if role == "permission"
        noko do |xml|
          xml.example **id_attr(node) do |ex|
            figure_title(node, ex)
            wrap_in_para(node, ex)
          end
        end.join("\n")
      end

      def style(n, t)
        return
      end

      def termdef_boilerplate_cleanup(xmldoc)
        return
      end

      def cleanup(xmldoc)
        requirement_cleanup_ogc(xmldoc, "recommendation")
        requirement_cleanup_ogc(xmldoc, "requirement")
        requirement_cleanup_ogc(xmldoc, "permission")
        super
      end

      def requirement_cleanup_ogc(xmldoc, lbl)
        xmldoc.xpath("//table").each do |t|
          td = t&.at("./tbody/tr/td[1]")&.text
          /^\s*(#{lbl}( \d+)?)\s*$/i.match td or next
          body = t&.at("./tbody/tr/td[2]") or next
          t.name = lbl
          t.children = body&.children
          label = t&.at("./p")&.remove or next
          label.name = "title"
          t.prepend_child label
        end
      end

      def html_converter(node)
        IsoDoc::Ogc::HtmlConvert.new(html_extract_attributes(node))
      end

      def pdf_converter(node)
        IsoDoc::Ogc::PdfConvert.new(html_extract_attributes(node))
      end

      def word_converter(node)
        IsoDoc::Ogc::WordConvert.new(doc_extract_attributes(node))
      end
    end
  end
end
