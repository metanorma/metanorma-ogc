require "isodoc"
require_relative "metadata"
require "fileutils"

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

      def annex_name(annex, name, div)
        div.h1 **{ class: "Annex" } do |t|
          t << "#{get_anchors[annex['id']][:label]} "
          t.br
          t.b do |b|
          name&.children&.each { |c2| parse(c2, b) }
        end
        end
      end

      def pre_parse(node, out)
        out.pre node.text # content.gsub(/</, "&lt;").gsub(/>/, "&gt;")
      end

      def term_defs_boilerplate(div, source, term, preface)
        if source.empty? && term.nil?
          div << @no_terms_boilerplate
        else
          div << term_defs_boilerplate_cont(source, term)
        end
      end

      def error_parse(node, out)
        # catch elements not defined in ISO
        case node.name
        when "pre"
          pre_parse(node, out)
        when "keyword"
          out.span node.text, **{ class: "keyword" }
        else
          super
        end
      end

      def fileloc(loc)
        File.join(File.dirname(__FILE__), loc)
      end

      def cleanup(docxml)
        super
        term_cleanup(docxml)
      end

      def term_cleanup(docxml)
        docxml.xpath("//p[@class = 'Terms']").each do |d|
          h2 = d.at("./preceding-sibling::*[@class = 'TermNum'][1]")
          h2.add_child("&nbsp;")
          h2.add_child(d.remove)
        end
        docxml
      end

      def info(isoxml, out)
        @meta.keywords isoxml, out
        super
      end

      def load_yaml(lang, script)
        y = if @i18nyaml then YAML.load_file(@i18nyaml)
            elsif lang == "en"
              YAML.load_file(File.join(File.dirname(__FILE__), "i18n-en.yaml"))
            else
              YAML.load_file(File.join(File.dirname(__FILE__), "i18n-en.yaml"))
            end
        super.merge(y)
      end

            def keywords(_docxml, out)
        kw = @meta.get[:keywords]
        kw.empty? and return
        out.div **{ class: "Section3" } do |div|
          clause_name(nil, "Keywords", div,  class: "IntroTitle")
          div.p "The following are keywords to be used by search engines and document catalogues."
          div.p kw.join(", ")
        end
      end

      SUBMITTINGORGS =
        "//bibdata/contributor[role/@type = 'author']/organization/name".freeze

      def submittingorgs(docxml, out)
        orgs = []
        docxml.xpath(ns(SUBMITTINGORGS)).each { |org| orgs << org.text }
        return if orgs.empty?
        out.div **{ class: "Section3" } do |div|
          clause_name(nil, "Submitting Organizations", div,  class: "IntroTitle")
          div.p "The following organizations submitted this Document to the Open Geospatial Consortium (OGC):"
          div.ul do |ul|
            orgs.each do |org|
              ul.li org
            end
          end
        end
      end

      def submitters(docxml, out)
        f = docxml.at(ns("//submitters")) || return
        out.div **{ class: "Section3" } do |div|
          clause_name(nil, "Submitters", div,  class: "IntroTitle")
          f.elements.each { |e| parse(e, div) unless e.name == "title" }
        end
      end

      def make_body2(body, docxml)
        body.div **{ class: "WordSection2" } do |div2|
          info docxml, div2
          keywords docxml, div2
          abstract docxml, div2
          foreword docxml, div2
          submittingorgs docxml, div2
          submitters docxml, div2
          div2.p { |p| p << "&nbsp;" } # placeholder
        end
        section_break(body)
      end
    end
  end
end
