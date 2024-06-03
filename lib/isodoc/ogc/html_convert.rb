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
        ret += html_head_kw
        ret += html_head_abstract
        ret += html_head_creator
        ret += html_head_date
        ret += html_head_title
        ret += html_head_dc
        ret
      end

      def html_head_abstract
        k = @meta.get[:abstract] and k = @c.encode(k)&.gsub("'", "&#x27;")
        (k.nil? || k.empty?) and return ""
        "<meta name='description' content='#{k}'/>\n" \
          "<meta name='DC.description' lang='#{@lang}' content='#{k}' />"
      end

      def html_head_kw
        k = @meta.get[:keywords].join(", ") and
          k = @c.encode(k).gsub("'", "&#x27;")
        k.empty? and return ""
        "<meta name='keywords' content='#{k}'/>" \
          "<meta name='DC.subject' lang='#{@lang}' content='#{k}' />"
      end

      def html_head_dc
        <<~HTML
          <link rel="profile" href="http://dublincore.org/documents/2008/08/04/dc-html/" />
          <link rel="schema.DC" href="http://purl.org/dc/elements/1.1/" />
          <meta name="DC.language" content="#{@lang}" />
          <meta name="DC.rights" lang="#{@lang}" content="CC-BY-4.0"/>
          <link rel="schema.DCTERMS" href="http://purl.org/dc/terms/" />
          <link rel="DCTERMS.license" href="https://www.ogc.org/license" />
        HTML
      end

      def html_head_creator
        k = @meta.get[:authors] and
          k = @c.encode(k.join(", ")).gsub("'", "&#x27;")
        (k.nil? || k.empty?) and return ""
        "<meta name='DC.creator' lang='#{@lang}' content='#{k}' />"
      end

      def html_head_date
        k = @meta.get[:revdate] || @meta.get[:ipublisheddate] and
          k = @c.encode(k)&.gsub("'", "&#x27;")
        (k.nil? || k.empty?) and return ""
        "<meta name='DC.date' content='#{k}' />"
      end

      def html_head_title
        k = @meta.get[:doctitle] and k = @c.encode(k)&.gsub("'", "&#x27;")
        (k.nil? || k.empty?) and return ""
        "<meta name='DC.title' lang='#{@lang}' content='#{k}' />"
      end

      def heading_anchors(html)
        super
        html.xpath("//p[@class = 'RecommendationTitle'] | " \
                   "//p[@class = 'RecommendationTestTitle']").each do |h|
          div = h.xpath("./ancestor::table[@id]")
          div.empty? and next
          heading_anchor(h, div[-1]["id"])
        end
        html
      end

      include BaseConvert
      include Init
    end
  end
end
