require "asciidoctor"
require "asciidoctor/standoc/converter"
require "fileutils"
require_relative "front"

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

      def title_validate(root)
        nil
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

      def section_validate(doc)
        sections_sequence_validate(doc.root)
      end

      STANDARDTYPE = %w{standard standard-with-suite abstract-specification
      community-standard profile}.freeze

      # spec of permissible section sequence
      # we skip normative references, it goes to end of list
      SEQ = 
        [
          {
            msg: "Prefatory material must be followed by (clause) Scope",
            val: [{ tag: "clause", title: "Scope" }],
          },
          {
            msg: "Scope must be followed by Conformance",
            val: [{ tag: "clause", title: "Conformance" }],
          },
          {
            msg: "Normative References must be followed by "\
            "Terms and Definitions",
            val: [
              { tag: "terms", title: "Terms and definitions" },
              { tag: "clause", title: "Terms and definitions" },
              {
                tag: "terms",
                title: "Terms, definitions, symbols and abbreviated terms",
              },
              {
                tag: "clause",
                title: "Terms, definitions, symbols and abbreviated terms",
              },
            ],
          },
      ].freeze

      def seqcheck(names, msg, accepted)
        n = names.shift
        unless accepted.include? n
          warn "OGC style: #{msg}"
          names = []
        end
        names
      end

      def sections_sequence_validate(root)
        return unless STANDARDTYPE.include? root&.at("//bibdata/@type")&.text
        f = root.at("//sections").elements
        names = f.map { |s| { tag: s.name, title: s&.at("./title")&.text } }
        names = seqcheck(names, SEQ[0][:msg], SEQ[0][:val]) || return
        names = seqcheck(names, SEQ[1][:msg], SEQ[1][:val]) || return
        names = seqcheck(names, SEQ[2][:msg], SEQ[2][:val]) || return
        n = names.shift
        if !n.nil? && n[:tag] == "definitions"
          n = names.shift
        end
        unless n
          warn "OGC style: Document must contain at least one clause"
          return
        end
        root.at("//references | //clause[descendant::references][not(parent::clause)]") or
          seqcheck([{tag: "clause"}], 
                   "Normative References are mandatory", [{tag: "references"}])
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
        return requirement(node, "recommendation") if node.attr("style") == "recommendation"
        return requirement(node, "requirement") if node.attr("style") == "requirement"
        return requirement(node, "permission") if node.attr("style") == "permission"
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
        recommendation_cleanup(xmldoc)
        requirement_cleanup(xmldoc)
        permission_cleanup(xmldoc)
        super
      end

      def recommendation_cleanup(xmldoc)
        xmldoc.xpath("//table").each do |t|
          td = t&.at("./tbody/tr/td[1]")&.text
          /^\s*(Recommendation( \d+)?)\s*$/.match td or next
          body = t&.at("./tbody/tr/td[2]") or next
          t.name = "recommendation"
          t.children = body&.children
          label = t&.at("./p")&.remove or next
          label.name = "name"
          t.prepend_child label
        end
      end

      def requirement_cleanup(xmldoc)
        xmldoc.xpath("//table").each do |t|
          td = t&.at("./tbody/tr/td[1]")&.text
          /^\s*(Requirement( \d+)?)\s*$/.match td or next
          body = t&.at("./tbody/tr/td[2]") or next
          t.name = "requirement"
          t.children = body&.children
          label = t&.at("./p")&.remove or next
          label.name = "name"
          t.prepend_child label
        end
      end

      def permission_cleanup(xmldoc)
        xmldoc.xpath("//table").each do |t|
          td = t&.at("./tbody/tr/td[1]")&.text
          /^\s*(Permission( \d+)?)\s*/.match td or next
          body = t&.at("./tbody/tr/td[2]") or next
          t.name = "permission"
          t.children = body&.children
          label = t&.at("./p")&.remove or next
          label.name = "name"
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
