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

      def pdf_stylesheet(docxml)
        doctype = docxml&.at(ns("//bibdata/ext/doctype"))&.text
        doctype = "other" unless %w(abstract-specification-topic best-practice
        change-request-supporting-document community-practice community-standard 
        discussion-paper engineering-report policy reference-model release-notes 
        standard user-guide test-suite white-paper).include? doctype
        "ogc.#{doctype}.xsl"
      end

      def convert(filename, file = nil, debug = false)
        file = File.read(filename, encoding: "utf-8") if file.nil?
        docxml, outname_html, dir = convert_init(file, filename, debug)
        /\.xml$/.match(filename) or
          filename = Tempfile.open([outname_html, ".xml"], encoding: "utf-8") do |f|
          f.write file
          f.path
        end
        FileUtils.rm_rf dir
        ::Metanorma::Output::XslfoPdf.new.convert(
          filename, outname_html + ".pdf", File.join(@libdir, pdf_stylesheet(docxml)))
      end
    end
  end
end
