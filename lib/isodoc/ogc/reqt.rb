require "isodoc"
require_relative "metadata"
require "fileutils"

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
        attr_code(id: node["id"], 
                  class: recommend_class(node),
                  style: "border-collapse:collapse;border-spacing:0;")
      end

      REQ_TBL_ATTR =
        { style: "vertical-align:top;", class: "recommend" }.freeze

      def recommendation_name(node, out, type)
        label, title, lbl = recommendation_labels(node)
        out.p **{ class: %w(verification abstracttest).include?(node["type"]) ?
                  "RecommendationTestTitle" : "RecommendationTitle" }  do |b|
          lbl = anchor(node['id'], :label, false)
          b << (lbl.nil? ? l10n("#{type}:") : l10n("#{type} #{lbl}:"))
          if title
            b << " "
            title.children.each { |n| parse(n,b) }
          end
        end
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

      def recommendation_attributes1(node)
        out = []
        oblig = node["obligation"] and out << ["Obligation", oblig]
        subj = node&.at(ns("./subject"))&.text and
          out << [%w(class conformanceclass).include?(node["type"]) ?
          "Target Type" : "Subject", subj]
        node.xpath(ns("./inherit")).each { |i| out << ["Dependency", i.text] }
        node.xpath(ns("./classification")).each do |c|
          tag = c.at(ns("./tag")) or next
          value = c.at(ns("./value")) or next
          out << [tag.text.capitalize, value.text]
        end
        out
      end

      def recommendation_attributes(node, out)
        ret = recommendation_attributes1(node)
        return if ret.empty?
        ret.each do |i|
          out.tr do |tr|
            tr.td i[0], **REQ_TBL_ATTR
            tr.td i[1], **REQ_TBL_ATTR
          end
        end
      end

      def requirement_component_parse(node, out)
        return if node["exclude"] == "true"
        node.elements.size == 1 && node.first_element_child.name == "dl" and
          return reqt_dl(node.first_element_child, out)
        out.tr do |tr|
          tr.td **REQ_TBL_ATTR.merge(colspan: 2) do |td|
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
        label = case node["type"]
                when "verification" then @labels["recommendationtest"]
                when "class" then @labels["recommendationclass"]
                when "abstracttest" then @labels["abstracttest"]
                when "conformanceclass" then @labels["conformanceclass"]
                else
                  @recommendation_lbl
                end
        recommendation_parse1(node, out, label)
      end

      def requirement_parse(node, out)
        label = case node["type"]
                when "verification" then @labels["requirementtest"]
                when "class" then @labels["requirementclass"]
                when "abstracttest" then @labels["abstracttest"]
                when "conformanceclass" then @labels["conformanceclass"]
                else
                  @requirement_lbl
                end
        recommendation_parse1(node, out, label)
      end

      def permission_parse(node, out)
        label = case node["type"]
                when "verification" then @labels["permissiontest"]
                when "class" then @labels["permissionclass"]
                when "abstracttest" then @labels["abstracttest"]
                when "conformanceclass" then @labels["conformanceclass"]
                else
                  @permission_lbl
                end
        recommendation_parse1(node, out, label)
      end

      FIRST_LVL_REQ = IsoDoc::Function::XrefGen::FIRST_LVL_REQ

      def sequential_permission_names(clause, klass, label)
        c = ::IsoDoc::Function::XrefGen::Counter.new
        clause.xpath(ns(".//#{klass}#{FIRST_LVL_REQ}")).each do |t|
          next if t["id"].nil? || t["id"].empty?
          id = c.increment(t).print
          @anchors[t["id"]] = anchor_struct(id, t, label, klass, t["unnumbered"])
          sequential_permission_children(t, id)
        end
      end

      def req_class_paths
        {  
          "class" => "@type = 'class'", 
          "test" => "@type = 'verification'", 
          "" => "not(@type = 'verification' or @type = 'class' or @type = 'abstracttest' or @type = 'conformanceclass')",
        }
      end

      def req_class_paths2
        {
          "abstracttest" => "@type = 'abstracttest'",
          "conformanceclass" => "@type = 'conformanceclass'",
        }
      end

      def sequential_permission_children(t, id)
        req_class_paths.each do |k, v|
          sequential_permission_names1(t, id, "permission[#{v}]", @labels["permission#{k}"])
          sequential_permission_names1(t, id, "requirement[#{v}]", @labels["requirement#{k}"])
          sequential_permission_names1(t, id, "recommendation[#{v}]",  @labels["recommendation#{k}"])
        end
        req_class_paths2.each do |k, v|
          sequential_permission_names1(t, id, "*[#{v}]", @labels[k])
        end
      end

      def sequential_permission_names1(block, lbl, klass, label)
        c = ::IsoDoc::Function::XrefGen::Counter.new
        block.xpath(ns("./#{klass}")).each do |t|
          next if t["id"].nil? || t["id"].empty?
          id = "#{lbl}#{hierfigsep}#{c.increment(t).print}"
          @anchors[t["id"]] = anchor_struct(id, t, label, klass, t["unnumbered"])
          sequential_permission_children(t, id)
        end
      end

      def sequential_asset_names(clause)
        sequential_table_names(clause)
        sequential_figure_names(clause)
        sequential_formula_names(clause)
        req_class_paths.each do |k, v|
          sequential_permission_names(clause, "permission[#{v}]", @labels["permission#{k}"])
          sequential_permission_names(clause, "requirement[#{v}]", @labels["requirement#{k}"])
          sequential_permission_names(clause, "recommendation[#{v}]",  @labels["recommendation#{k}"])
        end
        req_class_paths2.each do |k, v|
          sequential_permission_names(clause, "*[#{v}]", @labels[k])
        end
      end

      def hierarchical_asset_names(clause, num)
        hierarchical_table_names(clause, num)
        hierarchical_figure_names(clause, num)
        hierarchical_formula_names(clause, num)
        req_class_paths.each do |k, v|
          hierarchical_permission_names(clause, num, "permission[#{v}]", @labels["permission#{k}"])
          hierarchical_permission_names(clause, num, "requirement[#{v}]", @labels["requirement#{k}"])
          hierarchical_permission_names(clause, num, "recommendation[#{v}]",  @labels["recommendation#{k}"])
        end
        req_class_paths2.each do |k, v|
          hierarchical_permission_names(clause, num, "*[#{v}]", @labels[k])
        end
      end

      def hierarchical_permission_names(clause, num, klass, label)
        c = ::IsoDoc::Function::XrefGen::Counter.new
        clause.xpath(ns(".//#{klass}#{FIRST_LVL_REQ}")).each do |t|
          next if t["id"].nil? || t["id"].empty?
          lbl = "#{num}#{hiersep}#{c.increment(t).print}"
          @anchors[t["id"]] = anchor_struct(lbl, t, label, klass, t["unnumbered"])
          sequential_permission_children(t, lbl)
        end
      end
    end
  end
end
