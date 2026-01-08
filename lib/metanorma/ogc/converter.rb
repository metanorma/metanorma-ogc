require "asciidoctor"
require "metanorma/standoc/converter"
require "fileutils"
require "date"
require_relative "front"
require_relative "validate"
require_relative "cleanup"
require_relative "sections"

module Metanorma
  module Ogc
    class Converter < Standoc::Converter
      register_for "ogc"

      def init_toc(node)
        super
        @tocfigures = true
        @toctables = true
        @tocrecommendations = true
      end

      def default_requirement_model
        "ogc"
      end

      def boilerplate_file(_xmldoc)
        File.join(@libdir, "boilerplate.adoc")
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
            @log.add("OGC_16", nil, params: [d])
          @warned_doctype = true
          d = @default_doctype
        end
        d
      end

      def document_scheme(node)
        if r = node.attr("document-scheme")
          r == "2022" ? "2022" : "2018"
        elsif r = node.attr("published-date")
          published_date_scheme(r)
        elsif r = node.attr("copyright-year")
          r.to_i >= 2022 ? "2022" : "2018"
        else "2022"
        end
      end

      def published_date_scheme(date_str)
        published_date = parse_flexible_date(date_str) or return nil
        cutoff_date = Date.new(2021, 11, 8)
        published_date >= cutoff_date ? "2022" : "2018"
      rescue Date::Error, ArgumentError
        nil
      end

      def parse_flexible_date(date_str)
        case date_str
        when /^\d{4}$/
          Date.new(date_str.to_i, 1, 1)
        when /^\d{4}-\d{2}$/
          year, month = date_str.split("-").map(&:to_i)
          Date.new(year, month, 1)
        else
          Date.parse(date_str)
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

      def style(_node, _text)
        nil
      end

      def table_cell(node, xml_tr, tblsec)
        node.set_attr("valign", "middle")
        super
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
          ret += "<presentation-metadata><color-#{k}>" \
            "#{c[k]}</color-#{k}></presentation-metadata>"
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
        c = isolated_asciidoctor_convert(
          "= X\nA\n:semantic-metadata-headless: true\n" \
                   ":novalid:\n:docsubtype: implementation\n" \
                   ":doctype: standard\n\n#{text}\n",
          backend: flavour, header_footer: true,
        )
        Nokogiri::XML(c).at("//xmlns:sections")
      end
    end
  end
end

require_relative "log"
