require_relative "base_convert"
require "isodoc"

module IsoDoc
  module Ogc
    # A {Converter} implementation that generates PDF HTML output, and a
    # document schema encapsulation of the document for validation
    class PdfConvert < IsoDoc::XslfoPdfConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def pdf_stylesheet(_docxml)
        %w(white-paper).include? @doctype or @doctype = "standard"
        "ogc.#{@doctype}.xsl"
      end
    end
  end
end
