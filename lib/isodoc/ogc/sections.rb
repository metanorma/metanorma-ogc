module IsoDoc
  module Ogc
    module BaseConvert
      def intro_clause(f, out)
        out.div **{ class: "Section3", id: f["id"] } do |div|
          clause_name(nil, f&.at(ns("./title")), div, class: "IntroTitle")
          f.elements.each { |e| parse(e, div) unless e.name == "title" }
        end
      end

      def keywords(docxml, out)
        f = docxml.at(ns("//preface/clause[@type = 'keywords']")) || return
        intro_clause(f, out)
      end

      def submittingorgs(docxml, out)
        f = docxml.at(ns("//preface/clause[@type = 'submitting_orgs']")) || return
        intro_clause(f, out)
      end

      def security(docxml, out)
        f = docxml.at(ns("//preface/clause[@type = 'security']")) || return
        intro_clause(f, out)
      end

      def submitters(docxml, out)
        f = docxml.at(ns("//submitters")) || return
        intro_clause(f, out)
      end

      def preface(isoxml, out)
        isoxml.xpath(ns("//preface/clause[not(@type = 'keywords' or "\
                        "@type = 'submitting_orgs' or @type = 'security')]")).each do |f|
          intro_clause(f, out)
        end
      end

      def abstract(isoxml, out)
        f = isoxml.at(ns("//preface/abstract")) || return
        page_break(out)
        out.div **attr_code(id: f["id"]) do |s|
          clause_name(nil, f&.at(ns("./title")), s, class: "AbstractTitle")
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      def foreword(isoxml, out)
        f = isoxml.at(ns("//foreword")) || return
        page_break(out)
        out.div **attr_code(id: f["id"]) do |s|
          clause_name(nil, f&.at(ns("./title")), s, class: "ForewordTitle")
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      def acknowledgements(isoxml, out)
        f = isoxml.at(ns("//acknowledgements")) || return
        intro_clause(f, out)
      end

      def conformance(isoxml, out, num)
        f = isoxml.at(ns("//clause[@type = 'conformance']")) or return num
        out.div **attr_code(id: f["id"]) do |div|
          clause_name(nil, f&.at(ns("./title")), div, nil)
          f.elements.each { |e| parse(e, div) unless e.name == "title" }
        end
        num
      end
    end
  end
end
