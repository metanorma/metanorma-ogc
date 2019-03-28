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

      def annex_name(annex, name, div)
        div.h1 **{ class: "Annex" } do |t|
          t << "#{get_anchors[annex['id']][:label]} "
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

      def make_body2(body, docxml)
        body.div **{ class: "WordSection2" } do |div2|
          @prefacenum = 0
          info docxml, div2
          abstract docxml, div2
          keywords docxml, div2
          foreword docxml, div2
          submittingorgs docxml, div2
          submitters docxml, div2
          div2.p { |p| p << "&nbsp;" } # placeholder
        end
        section_break(body)
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
        super
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
              recommendation_label(node, td)
            end
            tr.td **{ valign: "top", class: "recommend" } do |td|
              recommend_name_parse(node, td)
              node.children.each { |n| parse(n, td) unless n.name == "name" }
            end
          end
        end
      end

      def recommendation_label(node, out)
        n = get_anchors[node["id"]]
        label = (n.nil? || n[:label].empty?) ?
          "Recommendation" : l10n("#{"Recommendation"} #{n[:label]}")
        out.p **{class: "RecommendationTitle" } do |p|
          p << label
        end
      end

      def requirement_parse(node, out)
        out.table **recommend_table_attr(node) do |t|
          t.tr do |tr|
            tr.td **REQ_TBL_ATTR do |td|
              requirement_label(node, td)
            end
            tr.td **{ valign: "top", class: "recommend" } do |td|
              recommend_name_parse(node, td)
              node.children.each { |n| parse(n, td) unless n.name == "name" }
            end
          end
        end
      end

      def requirement_label(node, out)
        n = get_anchors[node["id"]]
        label = (n.nil? || n[:label].empty?) ?
          "Requirement" : l10n("#{"Requirement"} #{n[:label]}")
        out.p **{class: "RecommendationTitle" } do |p|
          p << label
        end
      end

      def permission_parse(node, out)
        out.table **recommend_table_attr(node) do |t|
          t.tr do |tr|
            tr.td **REQ_TBL_ATTR do |td|
              permission_label(node, td)
            end
            tr.td **{ valign: "top", class: "recommend" } do |td|
              recommend_name_parse(node, td)
              node.children.each { |n| parse(n, td) unless n.name == "name" }
            end
          end
        end
      end

      def permission_label(node, out)
        n = get_anchors[node["id"]]
        label = (n.nil? || n[:label].empty?) ?
          "Permission" : l10n("#{"Permission"} #{n[:label]}")
        out.p **{class: "RecommendationTitle" } do |p|
          p << label
        end
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
        n = section_names(d.at(ns("//clause[title = 'Conformance']")), n, 1)
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
