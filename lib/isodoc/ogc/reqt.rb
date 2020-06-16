require "isodoc"
require_relative "reqt_xref"

module IsoDoc
  module Ogc
    module BaseConvert
      def recommend_class(node)
        return "recommendtest" if node["type"] == "verification"
        return "recommendtest" if node["type"] == "abstracttest"
        return "recommendclass" if node["type"] == "class"
        return "recommendclass" if node["type"] == "conformanceclass"
        "recommend"
      end

      def recommend_table_attr(node)
        attr_code(id: node["id"], class: recommend_class(node),
                  style: "border-collapse:collapse;border-spacing:0;"\
                 "#{keep_style(node}")
      end

      REQ_TBL_ATTR =
        { style: "vertical-align:top;", class: "recommend" }.freeze

      def recommendation_class(node)
        %w(verification abstracttest).include?(node["type"]) ?
                  "RecommendationTestTitle" : "RecommendationTitle"
      end

      def recommendation_name(node, out, type)
        label, title, lbl = recommendation_labels(node)
        out.p **{ class: recommendation_class(node) } do |b|
          if inject_crossreference_reqt?(node, label)
            lbl = anchor(@reqtlabels[label.text], :xref, false)
            b << (lbl.nil? ? l10n("#{type}:") : l10n("#{lbl}:"))
          else
            b << (lbl.nil? ? l10n("#{type}:") : l10n("#{type} #{lbl}:"))
          end
          recommendation_name1(title, node, label, b)
        end
      end

      def recommendation_name1(title, node, label, b)
        return unless  title && !inject_crossreference_reqt?(node, label)
        b << " "
        title.children.each { |n| parse(n,b) }
      end

      def recommend_title(node, out)
        label = node.at(ns("./label")) or return
        out.tr do |tr|
          tr.td **REQ_TBL_ATTR.merge(colspan: 2) do |td|
            td.p do |p|
              label.children.each { |n| parse(n, p) }
            end
          end
        end
      end

      # embedded reqts xref to top level reqts via label lookup
      def inject_crossreference_reqt?(node, label)
        !node.ancestors("requirement, recommendation, permission").empty? &&
          @reqtlabels[label&.text]
      end

      def recommendation_attributes1(node)
        out = []
        oblig = node["obligation"] and out << ["Obligation", oblig]
        subj = node&.at(ns("./subject"))&.text and out << [rec_subj(node), subj]
        node.xpath(ns("./inherit")).each do |i|
          out << recommendation_attr_parse(i, "Dependency")
        end
        node.xpath(ns("./classification")).each do |c|
          line = recommendation_attr_keyvalue(c, "tag", "value") and out << line
        end
        out
      end

      def rec_subj(node)
        %w(class conformanceclass).include?(node["type"]) ?
          "Target Type" : "Subject"
      end

      def recommendation_attr_parse(node, label)
        text = noko do |xml|
          node.children.each { |n| parse(n, xml) }
        end.join
        [label, text]
      end

      def recommendation_attr_keyvalue(node, key, value)
        tag = node.at(ns("./#{key}")) or return nil
        value = node.at(ns("./#{value}")) or return nil
        [tag.text.capitalize, value.text]
      end

      def recommendation_attributes(node, out)
        recommendation_attributes1(node).each do |i|
          out.tr do |tr|
            tr.td **REQ_TBL_ATTR do |td|
              td << i[0]
            end
            tr.td **REQ_TBL_ATTR do |td|
              td << i[1] 
            end
          end
        end
      end

      def requirement_component_parse(node, out)
        return if node["exclude"] == "true"
        node.elements.size == 1 && node.first_element_child.name == "dl" and
          return reqt_dl(node.first_element_child, out)
        out.tr do |tr|
          tr.td **REQ_TBL_ATTR.merge(colspan: 2).
            merge(reqt_component_attrs(node)) do |td|
            node.children.each { |n| parse(n, td) }
          end
        end
      end

      def reqt_dl(node, out)
        node.xpath(ns("./dt")).each do |dt|
          out.tr do |tr|
            tr.td **REQ_TBL_ATTR do |td|
              dt.children.each { |n| parse(n, td) }
            end
            dd = dt&.next_element and dd.name == "dd" or next
            tr.td **REQ_TBL_ATTR do |td|
              dd.children.each { |n| parse(n, td) }
            end
          end
        end
      end

      def recommendation_header(node, out, label)
        out.thead do |h|
          h.tr do |tr|
            tr.th **REQ_TBL_ATTR.merge(colspan: 2) do |td|
              recommendation_name(node, td, label)
            end
          end
        end
      end

      def recommendation_parse1(node, out, label)
        out.table **recommend_table_attr(node) do |t|
          recommendation_header(node, out, label)
          t.tbody do |b|
            recommend_title(node, b)
            recommendation_attributes(node, b)
            node.children.each do |n|
              parse(n, t) unless reqt_metadata_node(n)
            end
          end
        end
      end

      def recommendation_parse(node, out)
        recommendation_parse0(node, out, "recommendation")
      end

      def recommendation_parse0(node, out, r)
        label = case node["type"]
                when "verification" then @labels["#{r}test"]
                when "class" then @labels["#{r}class"]
                when "abstracttest" then @labels["abstracttest"]
                when "conformanceclass" then @labels["conformanceclass"]
                else 
                  case r
                  when "recommendation" then @recommendation_lbl
                  when "requirement" then @requirement_lbl
                  when "permission" then @permission_lbl
                  end
                end
        recommendation_parse1(node, out, label)
      end

      def requirement_parse(node, out)
        recommendation_parse0(node, out, "requirement")
      end

      def permission_parse(node, out)
        recommendation_parse0(node, out, "permission")
      end
    end
  end
end
