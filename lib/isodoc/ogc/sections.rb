module IsoDoc
  module Ogc
    module BaseConvert
      def front(isoxml, out)
        p = isoxml.at(ns("//preface")) or return
        p.elements.each do |e|
          if is_clause?(e.name)
            case e.name
            when "abstract" then abstract e, out
            when "foreword" then foreword e, out
            when "introduction" then introduction e, out
            when "submitters" then intro_clause e, out
            when "clause" then preface e, out
            when "acknowledgements" then acknowledgements e, out
            end
          else
            preface_block(e, out)
          end
        end
      end

      def preface(clause, out)
        case clause["type"]
        when "toc"
          table_of_contents(clause, out)
        when "executivesummary", "security", "submitting_orgs",
          "keywords"
          intro_clause(clause, out)
        else
          intro_clause(clause, out)
        end
      end

      def intro_clause(elem, out)
        out.div class: "Section3", id: elem["id"] do |div|
          clause_name(elem, elem&.at(ns("./title")), div,
                      class: "IntroTitle")
          elem.elements.each do |e|
            parse(e, div) unless e.name == "title"
          end
        end
      end

      def abstract(clause, out)
        page_break(out)
        out.div **attr_code(id: clause["id"]) do |s|
          clause_name(clause, clause.at(ns("./title")), s,
                      class: "AbstractTitle")
          clause.elements.each do |e|
            parse(e, s) unless e.name == "title"
          end
        end
      end

      def foreword(clause, out)
        page_break(out)
        out.div **attr_code(id: clause["id"]) do |s|
          clause_name(clause, clause&.at(ns("./title")), s,
                      class: "ForewordTitle")
          clause.elements.each do |e|
            parse(e, s) unless e.name == "title"
          end
        end
      end

      def acknowledgements(clause, out)
        intro_clause(clause, out)
      end

      def conformance(isoxml, out, num)
        f = isoxml.at(ns("//clause[@type = 'conformance']")) or return num
        out.div **attr_code(id: f["id"]) do |div|
          clause_name(f, f&.at(ns("./title")), div, nil)
          f.elements.each { |e| parse(e, div) unless e.name == "title" }
        end
        num
      end
    end
  end
end
