require_relative "base_convert"
require_relative "init"
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
      end

      def default_fonts(_options)
        {
          bodyfont: '"Times New Roman",serif',
          headerfont: '"Times New Roman",serif',
          monospacefont: '"Courier New",monospace',
          normalfontsize: "10.5pt",
          monospacefontsize: "10.0pt",
          footnotefontsize: "10.0pt",
          smallerfontsize: "10.0pt",
        }
      end

      def default_file_locations(_options)
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

      def convert1(docxml, filename, dir)
        if docxml&.at(ns("//bibdata/ext/doctype"))&.text == "white-paper"
          @wordstylesheet_name = html_doc_path("wordstyle_wp.scss")
          @standardstylesheet_name = html_doc_path("ogc_wp.scss")
          @wordcoverpage = html_doc_path("word_ogc_titlepage_wp.html")
          @wordintropage = html_doc_path("word_ogc_intro_wp.html")
          @header = html_doc_path("header_wp.html")
          @doctype = "white-paper"
          options[:bodyfont] = '"Arial",sans-serif'
          options[:headerfont] = '"Lato",sans-serif'
          options[:normalfontsize] = "11.0pt"
          options[:footnotefontsize] = "11.0pt"
        end
        super
      end

      def make_body(xml, docxml)
        body_attr = { lang: "EN-US", link: "blue", vlink: "#954F72" }
        xml.body **body_attr do |body|
          make_body1(body, docxml)
          make_body2(body, docxml)
          make_body3(body, docxml)
        end
      end

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
        \\h \\z \\t &quot;RecommendationTitle,RecommendationTestTitle,recommendationtitle,recommendationtesttitle&quot;#{' '}
        <span style='mso-element:field-separator'></span></span>
      TOC

      WORD_TOC_TABLE_PREFACE1 = <<~TOC.freeze
                          <span lang="EN-GB"><span
        style='mso-element:field-begin'></span><span
        style='mso-spacerun:yes'>&#xA0;</span>TOC
        \\h \\z \\t &quot;TableTitle,tabletitle&quot; <span
        style='mso-element:field-separator'></span></span>
      TOC

      WORD_TOC_FIGURE_PREFACE1 = <<~TOC.freeze
                                      <span lang="EN-GB"><span
        style='mso-element:field-begin'></span><span
        style='mso-spacerun:yes'>&#xA0;</span>TOC
        \\h \\z \\t &quot;FigureTitle,figuretitle&quot; <span
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
                %{\\1#{WORD_TOC_TABLE_PREFACE1}}) + WORD_TOC_SUFFIX1
      end

      def make_FigureWordToC(docxml)
        toc = ""
        docxml.xpath("//p[@class = 'FigureTitle']").each do |h|
          if h.xpath("./ancestor::div[@class = 'figure']").size > 1
            h["class"] = "SubfigureTitle"
          else
            toc += word_toc_entry(1, header_strip(h))
          end
        end
        toc.sub(/(<p class="MsoToc1">)/,
                %{\\1#{WORD_TOC_FIGURE_PREFACE1}}) + WORD_TOC_SUFFIX1
      end

      def make_RecommendationWordToC(docxml)
        toc = ""
        docxml.xpath("//p[@class = 'RecommendationTitle' or @class = 'RecommendationTestTitle']").sort_by do |h|
          recommmendation_sort_key(h.text)
        end.each do |h|
          toc += word_toc_entry(1, header_strip(h))
        end
        toc.sub(/(<p class="MsoToc1">)/,
                %{\\1#{WORD_TOC_RECOMMENDATION_PREFACE1}}) + WORD_TOC_SUFFIX1
      end

      def recommmendation_sort_key(header)
        m = /^([^0-9]+) (\d+)/.match(header) || /^([^:]+)/.match(header)
        "#{recommmendation_sort_key1(m[1])}::#{'%04d' % m[2].to_i}"
      end

      def recommmendation_sort_key1(type)
        case type.downcase
        when "requirements class" then "01"
        when "recommendations class" then "02"
        when "permissions class" then "03"
        when "requirement" then "04"
        when "recommendation" then "05"
        when "permission" then "06"
        when "conformance class" then "07"
        when "abstract test" then "08"
        when "requirements test" then "09"
        when "recommendations test" then "10"
        when "permissions test" then "11"
        else "z"
        end
      end

      def make_body2(body, docxml)
        body.div **{ class: "WordSection2" } do |div2|
          @prefacenum = 0
          info docxml, div2
          boilerplate docxml, div2
          preface_block docxml, div2
          abstract docxml, div2
          executivesummary docxml, div2
          keywords docxml, div2
          foreword docxml, div2
          introduction docxml, div2
          security docxml, div2
          submittingorgs docxml, div2
          submitters docxml, div2
          preface docxml, div2
          acknowledgements docxml, div2
          div2.p { |p| p << "&nbsp;" } # placeholder
        end
        section_break(body)
      end

      def word_cleanup(docxml)
        super
        word_recommend_cleanup(docxml)
        word_copyright_cleanup(docxml)
        word_license_cleanup(docxml)
        word_term_cleanup(docxml)
        docxml
      end

      def word_license_cleanup(docxml)
        x = "//div[@class = 'boilerplate-license']//p[not(@class)]"
        docxml.xpath(x).each do |p|
          p["class"] = "license"
        end
      end

      # center only the Copyright notice
      def word_copyright_cleanup(docxml)
        x = "//div[@class = 'boilerplate-copyright']/div[1]/p[not(@class)]"
        docxml.xpath(x).each { |p| p["align"] = "center" }
        return unless @doctype == "white-paper"

        docxml.xpath("//div[@class = 'boilerplate-copyright']//p[not(@class)]")
          .each { |p| p["class"] = "license" }
        docxml.xpath("//div[@class = 'boilerplate-legal']//p[not(@class)]")
          .each { |p| p["class"] = "license" }
      end

      def word_term_cleanup(docxml)
        docxml.xpath("//p[@class = 'TermNum']//p[@class = 'Terms']").each do |p|
          p.replace(p.children)
        end
      end

      def word_recommend_cleanup(docxml)
        docxml.xpath("//table[@class = 'recommendtest']/thead/tr").each do |tr|
          style_update(tr, "background:#C9C9C9;")
        end
        docxml.xpath("//table[@class = 'recommend']/thead/tr").each do |tr|
          style_update(tr, "background:#A5A5A5;")
        end
        docxml.xpath("//table[@class = 'recommend']/tbody").each do |tr|
          tr.xpath("./tr").each_slice(2) do |_tr1, tr2|
            tr2 && style_update(tr2, "background:#C9C9C9;")
          end
        end
      end

      def toWord(result, filename, dir, header)
        result = from_xhtml(word_cleanup(to_xhtml(result)))
        @wordstylesheet = wordstylesheet_update
        Html2Doc.process(
          result,
          filename: filename, imagedir: @localdir,
          stylesheet: @wordstylesheet&.path,
          header_file: header&.path, dir: dir,
          asciimathdelims: [@openmathdelim, @closemathdelim],
          liststyles: { ul: @ulstyle, ol: @olstyle, steps: "l4" }
        )
        header&.unlink
        @wordstylesheet.unlink if @wordstylesheet.is_a?(Tempfile)
      end

      include BaseConvert
      include Init
    end
  end
end
