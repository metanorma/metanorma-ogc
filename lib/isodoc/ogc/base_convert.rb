require "isodoc"
require_relative "metadata"
require_relative "reqt"
require_relative "biblio"
require "fileutils"

module IsoDoc
  module Ogc
    module BaseConvert
      def annex_name(annex, name, div)
        div.h1 **{ class: "Annex" } do |t|
          t << "#{anchor(annex['id'], :label)} "
          t.br
          t.b do |b|
            name&.children&.each { |c2| parse(c2, b) }
          end
        end
      end

      def fileloc(loc)
        File.join(File.dirname(__FILE__), loc)
      end

      def cleanup(docxml)
        requirement_table_cleanup(docxml)
        super
        term_cleanup(docxml)
      end

      # table nested in table: merge label and caption into a single row
      def requirement_table_cleanup(docxml)
        docxml.xpath("//table[@class = 'recommendclass']//table").each do |t|
          x = t.at("./thead") and x.replace(x.children)
          x = t.at("./tbody") and x.replace(x.children)
          x = t.at("./tfoot") and x.replace(x.children)
          if x = t.at("./tr/th[@colspan = '2']") and
              y = t.at("./tr/td[@colspan = '2']")
            x["colspan"] = "1"
            y["colspan"] = "1"
            x.name = "td"
            p = x.at("./p[@class = 'RecommendationTitle']") and
              p.delete("class")
            x << y.dup
            y.parent.remove
          end
          t.replace(t.children)
        end
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
          clause_name(RomanNumerals.to_roman(@prefacenum).downcase,
                      "Keywords", div,  class: "IntroTitle")
          div.p "The following are keywords to be used by search engines and "\
            "document catalogues."
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
          clause_name(RomanNumerals.to_roman(@prefacenum).downcase,
                      "Submitting Organizations", div,  class: "IntroTitle")
          div.p "The following organizations submitted this Document to the "\
            "Open Geospatial Consortium (OGC):"
          div.ul do |ul|
            orgs.each { |org| ul.li org }
          end
        end
      end

      def submitters(docxml, out)
        f = docxml.at(ns("//submitters")) || return
        @prefacenum += 1
        out.div **{ class: "Section3" } do |div|
          clause_name(anchor(f['id'], :label), "Submitters", div,
                      class: "IntroTitle")
          f.elements.each { |e| parse(e, div) unless e.name == "title" }
        end
      end

      def preface(isoxml, out)
        title_attr = { class: "IntroTitle" }
        isoxml.xpath(ns("//preface/clause")).each do |f|
          @prefacenum += 1
          out.div **{ class: "Section3", id: f["id"] } do |div|
            clause_name(RomanNumerals.to_roman(@prefacenum).downcase,
                        f&.at(ns("./title")), div, title_attr)
            f.elements.each { |e| parse(e, div) unless e.name == "title" }
          end
        end
      end

      def preface_names_numbered(clause)
        return if clause.nil?
        @prefacenum += 1
        pref = RomanNumerals.to_roman(@prefacenum).downcase
        @anchors[clause["id"]] =
          { label: pref,
            level: 1, xref: preface_clause_name(clause), type: "clause" }
        clause.xpath(ns("./clause | ./terms | ./term | ./definitions | "\
                        "./references")).each_with_index do |c, i|
          section_names1(c, "#{pref}.#{i + 1}", 2)
        end
      end

      def abstract(isoxml, out)
        f = isoxml.at(ns("//preface/abstract")) || return
        @prefacenum += 1
        page_break(out)
        out.div **attr_code(id: f["id"]) do |s|
          clause_name(anchor(f["id"], :label), @abstract_lbl, s,
                      class: "AbstractTitle")
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      def foreword(isoxml, out)
        f = isoxml.at(ns("//foreword")) || return
        @prefacenum += 1
        page_break(out)
        out.div **attr_code(id: f["id"]) do |s|
          clause_name(anchor(f["id"], :label), @foreword_lbl, s,
                      class: "ForewordTitle")
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      def acknowledgements(isoxml, out)
        f = isoxml.at(ns("//acknowledgements")) || return
        @prefacenum += 1
        out.div **{ class: "Section3", id: f["id"] } do |div|
          clause_name(anchor(f["id"], :label), f&.at(ns("./title")), div,
                      class: "IntroTitle")
          f.elements.each { |e| parse(e, div) unless e.name == "title" }
        end
      end

      def example_parse(node, out)
        name = node.at(ns("./name"))
        sourcecode_name_parse(node, out, name) if name
        super
      end

      def initial_anchor_names(d)
        @prefacenum = 0
        preface_names_numbered(d.at(ns("//preface/abstract")))
        @prefacenum += 1 if d.at(ns("//keyword"))
        preface_names_numbered(d.at(ns("//foreword")))
        preface_names_numbered(d.at(ns("//introduction")))
        @prefacenum += 1 if d.at(ns(SUBMITTINGORGS))
        preface_names_numbered(d.at(ns("//submitters")))
        d.xpath(ns("//preface/clause")).each do |c|
          preface_names_numbered(c)
        end
        preface_names_numbered(d.at(ns("//acknowledgements")))
        sequential_asset_names(d.xpath(ns(
          "//preface/abstract | //foreword | //introduction | "\
          "//submitters | //acknowledgements | //preface/clause")))
        n = section_names(d.at(ns("//clause[title = 'Scope']")), 0, 1)
        n = section_names(d.at(ns("//clause[title = 'Conformance']")), n, 1)
        n = section_names(d.at(ns(
          "//references[title = 'Normative References' or "\
          "title = 'Normative references']")), n, 1)
        n = section_names(
          d.at(ns("//sections/terms | //sections/clause[descendant::terms]")),
          n, 1)
        n = section_names(d.at(ns("//sections/definitions")), n, 1)
        middle_section_asset_names(d)
        clause_names(d, n)
        termnote_anchor_names(d)
        termexample_anchor_names(d)
      end

      MIDDLE_CLAUSE =
        "//clause[parent::sections][not(xmlns:title = 'Scope' or "\
        "xmlns:title = 'Conformance')][not(descendant::terms)]".freeze

      def middle_section_asset_names(d)
        middle_sections = "//clause[title = 'Scope' or title = 'Conformance'] "\
          "| //foreword | //introduction | //preface/abstract | "\
          "//submitters | //acknowledgements | //preface/clause | "\
          "//references[title = 'Normative References' or title = "\
          "'Normative references'] | //sections/terms | "\
          "//sections/definitions | //clause[parent::sections]"
        sequential_asset_names(d.xpath(ns(middle_sections)))
      end

      def conformance(isoxml, out, num)
        f = isoxml.at(ns("//clause[title = 'Conformance']")) or return num
        out.div **attr_code(id: f["id"]) do |div|
          num = num + 1
          clause_name(num, "Conformance", div, nil)
          f.elements.each { |e| parse(e, div) unless e.name == "title" }
        end
        num
      end

      def middle(isoxml, out)
        middle_title(out)
        i = scope isoxml, out, 0
        i = conformance isoxml, out, i
        i = norm_ref isoxml, out, i
        i = terms_defs isoxml, out, i
        i = symbols_abbrevs isoxml, out, i
        clause isoxml, out
        annex isoxml, out
        bibliography isoxml, out
      end
    end
  end
end
