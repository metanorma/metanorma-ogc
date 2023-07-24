require_relative "base_convert"
require_relative "init"
require "fileutils"
require "isodoc"
require_relative "metadata"

module IsoDoc
  module Ogc
    class HtmlConvert < IsoDoc::HtmlConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def default_fonts(_options)
        {
          bodyfont: '"Overpass",sans-serif',
          headerfont: '"Overpass",sans-serif',
          monospacefont: '"Space Mono",monospace',
          normalfontsize: "16px",
          monospacefontsize: "0.8em",
          footnotefontsize: "0.9em",
        }
      end

      def default_file_locations(_options)
        {
          htmlstylesheet: html_doc_path("htmlstyle.scss"),
          htmlcoverpage: html_doc_path("html_ogc_titlepage.html"),
          htmlintropage: html_doc_path("html_ogc_intro.html"),
        }
      end

      def googlefonts
        <<~HEAD.freeze
          <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i|Space+Mono:400,700" rel="stylesheet"/>
          <link href="https://fonts.googleapis.com/css?family=Overpass:300,300i,600,900" rel="stylesheet"/>
          <link href="https://fonts.googleapis.com/css?family=Teko:300,400,500" rel="stylesheet"/>
        HEAD
      end

      def admonition_class(node)
        case node["type"]
        when "important" then "Admonition.Important"
        when "warning" then "Admonition.Warning"
        else "Admonition"
        end
      end

      def make_body(xml, docxml)
        body_attr = { lang: "EN-US", link: "blue", vlink: "#954F72",
                      "xml:lang": "EN-US", class: "container" }
        xml.body **body_attr do |body|
          make_body1(body, docxml)
          make_body2(body, docxml)
          make_body3(body, docxml)
        end
      end

      def make_body3(body, docxml)
        @prefacenum = 0
        super
      end

      def authority_cleanup(docxml)
        authority_cleanup1(docxml, "contact")
        super
      end

      def html_head
        ret = super
        k = @meta.get[:keywords].join(", ")
        k.empty? or ret += "<meta name='keywords' content='#{k}'/>"
        k = @meta.get[:abstract]
        (k.nil? || k.empty?) or
          ret += "<meta name='description' content='#{k}'/>"
        ret
      end

      include BaseConvert
      include Init
    end
  end
end
