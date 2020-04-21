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

      def convert(filename, file = nil, debug = false)
        file = File.read(filename, encoding: "utf-8") if file.nil?
        docxml, outname_html, dir = convert_init(file, filename, debug)
        doctype = docxml&.at(ns("//bibdata/ext/doctype"))&.text
        doctype = "other" unless %w(community-standard engineering-report policy
        reference-model release-notes standard user-guide test-suite).include? doctype
        FileUtils.rm_rf dir
        ::Metanorma::Output::XslfoPdf.new.convert(
          filename, outname_html + ".pdf",
          File.join(@libdir, "unece.#{doctype}.xsl"))
      end
    end
  end
end

