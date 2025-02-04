module IsoDoc
  module Ogc
    module BaseConvert
      def top_element_render(node, out)
        case node.name
        when "submitters" then intro_clause node, out
        else super
        end
      end

      def preface(clause, out)
        case clause["type"]
        when "toc"
          table_of_contents(clause, out)
        else
          intro_clause(clause, out)
        end
      end

      def sections_names
        super + %w[submitters]
      end

      def intro_clause(elem, out)
        out.div class: "Section3", id: elem["id"] do |div|
          clause_name(elem, elem&.at(ns("./fmt-title")), div,
                      class: "IntroTitle")
          elem.elements.each do |e|
            parse(e, div) unless e.name == "fmt-title"
          end
        end
      end

      def abstract(clause, out)
        page_break(out)
        out.div **attr_code(id: clause["id"]) do |s|
          clause_name(clause, clause.at(ns("./fmt-title")), s,
                      class: "AbstractTitle")
          clause.elements.each do |e|
            parse(e, s) unless e.name == "fmt-title"
          end
        end
      end

      def foreword(clause, out)
        page_break(out)
        out.div **attr_code(id: clause["id"]) do |s|
          clause_name(clause, clause&.at(ns("./fmt-title")), s,
                      class: "ForewordTitle")
          clause.elements.each do |e|
            parse(e, s) unless e.name == "fmt-title"
          end
        end
      end

      def acknowledgements(clause, out)
        intro_clause(clause, out)
      end
    end
  end
end
