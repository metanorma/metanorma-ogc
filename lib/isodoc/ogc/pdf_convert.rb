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
    end
  end
end
