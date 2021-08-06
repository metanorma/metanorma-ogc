require "metanorma/processor"

module Metanorma
  module Ogc
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


      def fonts_manifest
        {
          "Lato" => nil,
          "Lato Light" => nil,
          "Arial" => nil,
          "STIX Two Math" => nil,
          "Source Han Sans" => nil,
          "Source Han Sans Normal" => nil,
          "Fira Code" => nil,
          "Courier New" => nil,
          "Times New Roman" => nil,
          "Overpass" => nil,
          "Space Mono" => nil,
        }
      end

      def version
        "Metanorma::Ogc #{Metanorma::Ogc::VERSION}"
      end

      def output(isodoc_node, inname, outname, format, options={})
        case format
        when :html
          IsoDoc::Ogc::HtmlConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :doc
          IsoDoc::Ogc::WordConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :pdf
          IsoDoc::Ogc::PdfConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :presentation
          IsoDoc::Ogc::PresentationXMLConvert.new(options).convert(inname, isodoc_node, nil, outname)
        else
          super
        end
      end
    end
  end
end
