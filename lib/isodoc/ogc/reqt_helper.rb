module IsoDoc
  module Ogc
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def reqt_ids(docxml)
        docxml.xpath(ns("//requirement | //recommendation | //permission"))
          .each_with_object({}) do |r, m|
            id = r.at(ns("./identifier")) or next
            m[id.text] = r["id"]
          end
      end

      def reqt_links(docxml)
        docxml.xpath(ns("//requirement | //recommendation | //permission"))
          .each_with_object({}) do |r, m|
            next unless %w(conformanceclass
                           verification).include?(r["type"])

            subj = r.at(ns("./classification[tag = 'target']/value"))
            id = r.at(ns("./identifier"))
            next unless subj && id

            m[subj.text] = { lbl: id.text, id: r["id"] }
          end
      end

      def rec_subj(node)
        case node["type"]
        when "class" then "Target type"
        else "Subject"
        end
      end

      def rec_target(node)
        case node["type"]
        when "class" then "Target type"
        when "conformanceclass" then "Requirements class"
        when "verification", "abstracttest" then "Requirement"
        else "Target"
        end
      end

      def recommendation_link(ident)
        test = @reqt_links[ident&.strip] or return nil
        "<xref target='#{test[:id]}'>#{test[:lbl]}</xref>"
      end

      def recommendation_id(ident)
        test = @reqt_ids[ident&.strip] or return nil
        "<xref target='#{test}'>#{ident.strip}</xref>"
      end

      def recommendation_class_label(node)
        case node["type"]
        when "verification" then @i18n.get["#{node.name}test"]
        when "class" then @i18n.get["#{node.name}class"]
        when "abstracttest" then @i18n.get["abstracttest"]
        when "conformanceclass" then @i18n.get["conformanceclass"]
        else
          case node.name
          when "recommendation" then @i18n.recommendation
          when "requirement" then @i18n.requirement
          when "permission" then @i18n.permission
          end
        end
      end

      def recommend_class(node)
        case node["type"]
        when "verification", "abstracttest" then "recommendtest"
        when "class", "conformanceclass" then "recommendclass"
        else "recommend"
        end
      end

      def recommend_name_class(node)
        if %w(verification abstracttest).include?(node["type"])
          "RecommendationTestTitle"
        else "RecommendationTitle"
        end
      end
    end
  end
end
