require "metanorma/processor"

module Metanorma
  module Ogc
    def self.fonts_used
      {
        doc: ["Arial", "Courier New", "Times New Roman"],
        pdf: ["Arial", "Courier New", "Times New Roman"],
        html: ["Overpass", "Space Mono"]
      }
    end

    class Processor < Metanorma::Processor

      def initialize
        @short = :ogc
        @input_format = :asciidoc
        @asciidoctor_backend = :ogc
      end

      def output_formats
        super.merge(
          html: "html",
          doc: "doc",
          pdf: "pdf"
        )
      end

      def version
        "Metanorma::Ogc #{Metanorma::Ogc::VERSION}"
      end

      def input_to_isodoc(file, filename)
        Metanorma::Input::Asciidoc.new.process(file, filename, @asciidoctor_backend)
      end

      def output(isodoc_node, outname, format, options={})
        case format
        when :html
          IsoDoc::Ogc::HtmlConvert.new(options).convert(outname, isodoc_node)
        when :doc
          IsoDoc::Ogc::WordConvert.new(options).convert(outname, isodoc_node)
        when :pdf
          IsoDoc::Ogc::PdfConvert.new(options).convert(outname, isodoc_node)
        else
          super
        end
      end
    end
  end
end
