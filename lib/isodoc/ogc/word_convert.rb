require_relative "base_convert"
require "fileutils"
require "isodoc"
require_relative "metadata"

module IsoDoc
  module Ogc
    # A {Converter} implementation that generates Word output, and a document
    # schema encapsulation of the document for validation

    class WordConvert < IsoDoc::WordConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
        #FileUtils.cp html_doc_path('logo.jpg'), "logo.jpg"
      end

      def default_fonts(options)
        {
          bodyfont: (options[:script] == "Hans" ? '"SimSun",serif' : '"Times New Roman",serif'),
          headerfont: (options[:script] == "Hans" ? '"SimHei",sans-serif' : '"Times New Roman",serif'),
          monospacefont: '"Courier New",monospace'
        }
      end

      def default_file_locations(options)
        {
          wordstylesheet: html_doc_path("wordstyle.scss"),
          standardstylesheet: html_doc_path("ogc.scss"),
          header: html_doc_path("header.html"),
          wordcoverpage: html_doc_path("word_ogc_titlepage.html"),
          wordintropage: html_doc_path("word_ogc_intro.html"),
          ulstyle: "l3",
          olstyle: "l2",
        }
      end


      def metadata_init(lang, script, labels)
        @meta = Metadata.new(lang, script, labels)
      end

      def make_body(xml, docxml)
        body_attr = { lang: "EN-US", link: "blue", vlink: "#954F72" }
        xml.body **body_attr do |body|
          make_body1(body, docxml)
          make_body2(body, docxml)
          make_body3(body, docxml)
        end
      end

=begin
      def make_body2(body, docxml)
        body.div **{ class: "WordSection2" } do |div2|
          info docxml, div2
          div2.p { |p| p << "&nbsp;" } # placeholder
        end
        section_break(body)
      end
=end

      def insert_toc(intro, docxml, level)
        toc = ""
        toc += make_WordToC(docxml, level)
        if docxml.at("//p[@class = 'TableTitle']")
          toc += %{<p class="TOCTitle">List of Tables</p>}
          toc += make_TableWordToC(docxml)
        end
        if docxml.at("//p[@class = 'FigureTitle']")
          toc += %{<p class="TOCTitle">List of Figures</p>}
          toc += make_FigureWordToC(docxml)
        end
        if docxml.at("//p[@class = 'RecommendationTitle']")
          toc += %{<p class="TOCTitle">List of Recommendations</p>}
          toc += make_RecommendationWordToC(docxml)
        end
        intro.sub(/WORDTOC/, toc)
      end

      WORD_TOC_RECOMMENDATION_PREFACE1 = <<~TOC.freeze
                          <span lang="EN-GB"><span
        style='mso-element:field-begin'></span><span
        style='mso-spacerun:yes'>&#xA0;</span>TOC
        \\h \\z \\t &quot;RecommendationTitle,1&quot; <span
        style='mso-element:field-separator'></span></span>
      TOC

      WORD_TOC_TABLE_PREFACE1 = <<~TOC.freeze
                          <span lang="EN-GB"><span
        style='mso-element:field-begin'></span><span
        style='mso-spacerun:yes'>&#xA0;</span>TOC
        \\h \\z \\t &quot;TableTitle,1&quot; <span
        style='mso-element:field-separator'></span></span>
      TOC

      WORD_TOC_FIGURE_PREFACE1 = <<~TOC.freeze
                                      <span lang="EN-GB"><span
        style='mso-element:field-begin'></span><span
        style='mso-spacerun:yes'>&#xA0;</span>TOC
        \\h \\z \\t &quot;FigureTitle,1&quot; <span
        style='mso-element:field-separator'></span></span>
      TOC

      def header_strip(h)
        h = h.to_s.gsub(/<\/?p[^>]*>/, "")
        super
      end

      def make_TableWordToC(docxml)
        toc = ""
        docxml.xpath("//p[@class = 'TableTitle']").each do |h|
          toc += word_toc_entry(1, header_strip(h))
        end
        toc.sub(/(<p class="MsoToc1">)/,
                %{\\1#{WORD_TOC_TABLE_PREFACE1}}) +  WORD_TOC_SUFFIX1
      end

      def make_FigureWordToC(docxml)
        toc = ""
        docxml.xpath("//p[@class = 'FigureTitle']").each do |h|
          toc += word_toc_entry(1, header_strip(h))
        end
        toc.sub(/(<p class="MsoToc1">)/,
                %{\\1#{WORD_TOC_FIGURE_PREFACE1}}) +  WORD_TOC_SUFFIX1
      end

      def make_RecommendationWordToC(docxml)
        toc = ""
        docxml.xpath("//p[@class = 'RecommendationTitle']").each do |h|
          toc += word_toc_entry(1, header_strip(h))
        end
        toc.sub(/(<p class="MsoToc1">)/,
                %{\\1#{WORD_TOC_RECOMMENDATION_PREFACE1}}) +  WORD_TOC_SUFFIX1
      end

      def make_body2(body, docxml)
        body.div **{ class: "WordSection2" } do |div2|
          @prefacenum = 0
          info docxml, div2
          abstract docxml, div2
          keywords docxml, div2
          foreword docxml, div2
          introduction docxml, div2
          submittingorgs docxml, div2
          submitters docxml, div2
          div2.p { |p| p << "&nbsp;" } # placeholder
        end
        section_break(body)
      end

      include BaseConvert
    end
  end
end
