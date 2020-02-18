require_relative "base_convert"
require "fileutils"
require "isodoc"
require_relative "metadata"

module IsoDoc
  module Ogc

    # A {Converter} implementation that generates HTML output, and a document
    # schema encapsulation of the document for validation
    #
    class HtmlConvert < IsoDoc::HtmlConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def default_fonts(options)
        {
          bodyfont: (options[:script] == "Hans" ? '"SimSun",serif' : '"Overpass",sans-serif'),
          headerfont: (options[:script] == "Hans" ? '"SimHei",sans-serif' : '"Overpass",sans-serif'),
          monospacefont: '"Space Mono",monospace'
        }
      end

      def default_file_locations(_options)
        {
          htmlstylesheet: html_doc_path("htmlstyle.scss"),
          htmlcoverpage: html_doc_path("html_ogc_titlepage.html"),
          htmlintropage: html_doc_path("html_ogc_intro.html"),
          scripts: html_doc_path("scripts.html"),
        }
      end

      def metadata_init(lang, script, labels)
        @meta = Metadata.new(lang, script, labels)
      end

      def googlefonts
        <<~HEAD.freeze
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i|Space+Mono:400,700" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Overpass:300,300i,600,900" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Teko:300,400,500" rel="stylesheet">
        HEAD
      end

      def admonition_class(node)
        case node["type"]
        when "important" then "Admonition.Important"
        when "warning" then "Admonition.Warning"
        else
          "Admonition"
        end
      end

      def make_body(xml, docxml)
        body_attr = { lang: "EN-US", link: "blue", vlink: "#954F72", "xml:lang": "EN-US", class: "container" }
        xml.body **body_attr do |body|
          make_body1(body, docxml)
          make_body2(body, docxml)
          make_body3(body, docxml)
        end
      end

      def make_body3(body, docxml)
        body.div **{ class: "main-section" } do |div3|
          @prefacenum = 0
          boilerplate docxml, div3
          abstract docxml, div3
          keywords docxml, div3
          foreword docxml, div3
          introduction docxml, div3
          submittingorgs docxml, div3
          submitters docxml, div3
          acknowledgements docxml, div3
          middle docxml, div3
          footnotes div3
          comments div3
        end
      end

      def authority_cleanup(docxml)
        authority_cleanup1(docxml, "contact")
        super
      end

      include BaseConvert
    end
  end
end
