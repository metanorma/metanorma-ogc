require "isodoc"
require_relative "metadata"
require "fileutils"

module IsoDoc
  module Ogc

    # A {Converter} implementation that generates HTML output, and a document
    # schema encapsulation of the document for validation
    #
    class HtmlConvert < IsoDoc::HtmlConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
        #FileUtils.cp html_doc_path('logo.jpg'), "logo.jpg"
        #@files_to_delete << "logo.jpg"
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

      def html_head
        <<~HEAD.freeze
          <title>{{ doctitle }}</title>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

    <!--TOC script import-->
    <script type="text/javascript" src="https://cdn.rawgit.com/jgallen23/toc/0.3.2/dist/toc.min.js"></script>

    <!--Google fonts-->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i|Space+Mono:400,700" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Overpass:300,300i,600,900" rel="stylesheet">
    <!--Font awesome import for the link icon-->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/solid.css" integrity="sha384-rdyFrfAIC05c5ph7BKz3l5NG5yEottvO/DQ0dCrwD8gzeQDjYBHNr1ucUpQuljos" crossorigin="anonymous">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/fontawesome.css" integrity="sha384-u5J7JghGz0qUrmEsWzBQkfvc8nK3fUT7DCaQzNQ+q4oEXhGSx+P2OqjWsfIRB8QT" crossorigin="anonymous">
    <style class="anchorjs"></style>
        HEAD
      end

      def make_body(xml, docxml)
        body_attr = { lang: "EN-US", link: "blue", vlink: "#954F72", "xml:lang": "EN-US", class: "container" }
        xml.body **body_attr do |body|
          make_body1(body, docxml)
          make_body2(body, docxml)
          make_body3(body, docxml)
        end
      end

      def html_toc(docxml)
        docxml
      end

      def annex_name(annex, name, div)
        div.h1 **{ class: "Annex" } do |t|
          t << "#{get_anchors[annex['id']][:label]}"
          t.br
          t.b do |b|
            name&.children&.each { |c2| parse(c2, b) }
          end
        end
      end

      def term_defs_boilerplate(div, source, term, preface)
        if source.empty? && term.nil?
          div << @no_terms_boilerplate
        else
          div << term_defs_boilerplate_cont(source, term)
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
        @prefacenum += 1
        out.div **{ class: "Section3" } do |div|
          clause_name(RomanNumerals.to_roman(@prefacenum).downcase, "Keywords", div,  class: "IntroTitle")
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
        @prefacenum += 1
        out.div **{ class: "Section3" } do |div|
          clause_name(RomanNumerals.to_roman(@prefacenum).downcase, "Submitting Organizations", div,  class: "IntroTitle")
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
          clause_name(get_anchors[f['id']][:label], "Submitters", div,  class: "IntroTitle")
          f.elements.each { |e| parse(e, div) unless e.name == "title" }
        end
      end

      def make_body3(body, docxml)
        body.div **{ class: "main-section" } do |div3|
          @prefacenum = 0
          abstract docxml, div3
          keywords docxml, div3
          foreword docxml, div3
          submittingorgs docxml, div3
          submitters docxml, div3
          middle docxml, div3
          footnotes div3
          comments div3
        end
      end

      def preface_names(clause)
        return if clause.nil?
        @prefacenum += 1
        @anchors[clause["id"]] =
          { label: RomanNumerals.to_roman(@prefacenum).downcase,
            level: 1, xref: preface_clause_name(clause), type: "clause" }
        clause.xpath(ns("./clause | ./terms | ./term | ./definitions")).each_with_index do |c, i|
          section_names1(c, "#{@prefacenum}.#{i + 1}", 2)
        end
      end

      def abstract(isoxml, out)
        f = isoxml.at(ns("//preface/abstract")) || return
        @prefacenum += 1
        page_break(out)
        out.div **attr_code(id: f["id"]) do |s|
          clause_name(get_anchors[f["id"]][:label], @abstract_lbl, s, class: "AbstractTitle")
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      def foreword(isoxml, out)
        f = isoxml.at(ns("//foreword")) || return
        @prefacenum += 1
        page_break(out)
        out.div **attr_code(id: f["id"]) do |s|
          clause_name(get_anchors[f["id"]][:label], @foreword_lbl, s, class: "ForewordTitle")
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      def example_parse(node, out)
        name = node.at(ns("./name"))
        sourcecode_name_parse(node, out, name) if name
        out.table **example_table_attr(node) do |t|
          t.tr do |tr|
            tr.td **EXAMPLE_TBL_ATTR do |td| 
              td << example_label(node) 
            end
            tr.td **{ valign: "top", class: "example" } do |td|
              node.children.each { |n| parse(n, td) unless n.name == "name" }
            end
          end
        end
      end

      def error_parse(node, out)
        case node.name
        when "recommendation" then recommendation_parse(node, out)
        when "requirement" then requirement_parse(node, out)
        when "permission" then permission_parse(node, out)
        else
          super
        end
      end

      def anchor_names(docxml)
        super
        recommendation_anchor_names(docxml)
        requirement_anchor_names(docxml)
        permission_anchor_names(docxml)
      end

      def recommendation_anchor_names(docxml)
        docxml.xpath(ns("//recommendation")).each_with_index do |x, i|
          @anchors[x["id"]] = anchor_struct(i+1, nil, "Recommendation", "recommendation")
        end
      end

      def requirement_anchor_names(docxml)
        docxml.xpath(ns("//requirement")).each_with_index do |x, i|
          @anchors[x["id"]] = anchor_struct(i+1, nil, "Requirement", "requirement")
        end
      end

      def permission_anchor_names(docxml)
        docxml.xpath(ns("//permission")).each_with_index do |x, i|
          @anchors[x["id"]] = anchor_struct(i+1, nil, "Permission", "permission")
        end
      end

      def recommend_table_attr(node)
        attr_code(id: node["id"], class: "recommend",
                  cellspacing: 0, cellpadding: 0,
                  style: "border-collapse:collapse" )
      end

      REQ_TBL_ATTR =
        { valign: "top", class: "example_label",
          style: "width:100.0pt;padding:0 0 0 1em;margin-left:0pt" }.freeze

      def recommend_name_parse(node, div)
        name = node&.at(ns("./name"))&.text or return
        div.p do |p|
          p.b name
        end
      end

      def recommendation_parse(node, out)
        out.table **recommend_table_attr(node) do |t|
          t.tr do |tr|
            tr.td **REQ_TBL_ATTR do |td|
              td << recommendation_label(node)
            end
            tr.td **{ valign: "top", class: "recommend" } do |td|
              recommend_name_parse(node, td)
              node.children.each { |n| parse(n, td) unless n.name == "name" }
            end
          end
        end
      end

      def recommendation_label(node)
        n = get_anchors[node["id"]]
        return "Recommendation" if n.nil? || n[:label].empty?
        l10n("#{"Recommendation"} #{n[:label]}")
      end

      def requirement_parse(node, out)
        out.table **recommend_table_attr(node) do |t|
          t.tr do |tr|
            tr.td **REQ_TBL_ATTR do |td|
              td << requirement_label(node)
            end
            tr.td **{ valign: "top", class: "recommend" } do |td|
              recommend_name_parse(node, td)
              node.children.each { |n| parse(n, td) unless n.name == "name" }
            end
          end
        end
      end

      def requirement_label(node)
        n = get_anchors[node["id"]]
        return "Requirement" if n.nil? || n[:label].empty?
        l10n("#{"Requirement"} #{n[:label]}")
      end

      def permission_parse(node, out)
        out.table **recommend_table_attr(node) do |t|
          t.tr do |tr|
            tr.td **REQ_TBL_ATTR do |td|
              td << permission_label(node)
            end
            tr.td **{ valign: "top", class: "recommend" } do |td|
              recommend_name_parse(node, td)
              node.children.each { |n| parse(n, td) unless n.name == "name" }
            end
          end
        end
      end

      def permission_label(node)
        n = get_anchors[node["id"]]
        return "Permission" if n.nil? || n[:label].empty?
        l10n("#{"Permission"} #{n[:label]}")
      end


      def initial_anchor_names(d)
        @prefacenum = 0
        preface_names(d.at(ns("//preface/abstract")))
        @prefacenum += 1 if d.at(ns("//keyword"))
        preface_names(d.at(ns("//foreword")))
        #preface_names(d.at(ns("//introduction")))
        @prefacenum += 1 if d.at(ns(SUBMITTINGORGS))
        preface_names(d.at(ns("//submitters")))
        sequential_asset_names(d.xpath(ns("//preface/abstract | //foreword | //introduction | //submitters")))
        n = section_names(d.at(ns("//clause[title = 'Scope']")), 0, 1)
        n = section_names(d.at(ns(
          "//references[title = 'Normative References' or title = 'Normative references']")), n, 1)
        n = section_names(d.at(ns("//sections/terms | "\
                                  "//sections/clause[descendant::terms]")), n, 1)
        n = section_names(d.at(ns("//sections/definitions")), n, 1)
        middle_section_asset_names(d)
        clause_names(d, n)
        termnote_anchor_names(d)
        termexample_anchor_names(d)
      end

    end
  end
end
