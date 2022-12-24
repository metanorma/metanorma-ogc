require_relative "base_convert"
require_relative "init"
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
        body_attr = { lang: "EN-US", link: "blue", vlink: "#954F72",
                      "xml:lang": "EN-US", class: "container" }
        xml.body **body_attr do |body|
          make_body1(body, docxml)
          make_body2(body, docxml)
          make_body3(body, docxml)
        end
      end

      def make_body3(body, docxml)
        body.div class: "main-section" do |div3|
          @prefacenum = 0
          boilerplate docxml, div3
          preface_block docxml, div3
          abstract docxml, div3
          executivesummary docxml, div3
          keywords docxml, div3
          foreword docxml, div3
          introduction docxml, div3
          security docxml, div3
          submittingorgs docxml, div3
          submitters docxml, div3
          preface docxml, div3
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

      def convert1(docxml, filename, dir)
        docxml = preprocess_xslt(docxml)
        super
      end

      XSLT_PASS = <<~XSLT.freeze
        <xsl:template match="node() | @*">
            <xsl:copy>
                <xsl:apply-templates select="node() | @*"/>
            </xsl:copy>
        </xsl:template>
      XSLT

      def extract_preprocess_xslt(docxml, format)
        docxml.xpath(ns("/*/render/preprocess-xslt"))
          .each_with_object([]) do |p, m|
          (p["format"] || format).split(",").include?(format) or next
          m << p.children.to_xml.sub(%r{</xsl:stylesheet>},
                                     "#{XSLT_PASS}</xsl:stylesheet>")
        end
      end

      def preprocess_xslt(docxml)
        r = extract_preprocess_xslt(docxml, "html")
        r.each do |x|
          docxml = Nokogiri::XSLT(x).transform(docxml)
        end
        docxml
      end

      include BaseConvert
      include Init
    end
  end
end
