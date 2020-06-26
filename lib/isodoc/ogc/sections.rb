module IsoDoc
  module Ogc
    module BaseConvert
      def annex_name(annex, name, div)
        div.h1 **{ class: "Annex" } do |t|
          t << "#{@xrefs.anchor(annex['id'], :label)} "
          t.br
          t.b do |b|
            name&.children&.each { |c2| parse(c2, b) }
          end
        end
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

      def submittingorgs_path
        "//bibdata/contributor[role/@type = 'author']/organization/name"
      end

      def submittingorgs(docxml, out)
        orgs = []
        docxml.xpath(ns(submittingorgs_path)).each { |org| orgs << org.text }
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
          clause_name(@xrefs.anchor(f['id'], :label), "Submitters", div,
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

      def abstract(isoxml, out)
        f = isoxml.at(ns("//preface/abstract")) || return
        @prefacenum += 1
        page_break(out)
        out.div **attr_code(id: f["id"]) do |s|
          clause_name(@xrefs.anchor(f["id"], :label), @abstract_lbl, s,
                      class: "AbstractTitle")
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      def foreword(isoxml, out)
        f = isoxml.at(ns("//foreword")) || return
        @prefacenum += 1
        page_break(out)
        out.div **attr_code(id: f["id"]) do |s|
          clause_name(@xrefs.anchor(f["id"], :label), @foreword_lbl, s,
                      class: "ForewordTitle")
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      def acknowledgements(isoxml, out)
        f = isoxml.at(ns("//acknowledgements")) || return
        @prefacenum += 1
        out.div **{ class: "Section3", id: f["id"] } do |div|
          clause_name(@xrefs.anchor(f["id"], :label), f&.at(ns("./title")), div,
                      class: "IntroTitle")
          f.elements.each { |e| parse(e, div) unless e.name == "title" }
        end
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
    end
  end
end
