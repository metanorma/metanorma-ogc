require "isodoc"
require_relative "metadata"
require "fileutils"

module IsoDoc
  module Ogc
    module BaseConvert
      def recommend_class(node)
        return "recommendtest" if node["type"] == "verification"
        return "recommendclass" if node["type"] == "class"
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
        out.p **{ class: node["type"] == "verification" ?
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
          out << [node["type"] == "class" ? "Target Type" : "Subject", subj]
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
                else
                  @recommendation_lbl
                end
        recommendation_parse1(node, out, label)
      end

      def requirement_parse(node, out)
        label = case node["type"]
                when "verification" then @labels["requirementtest"]
                when "class" then @labels["requirementclass"]
                else
                  @requirement_lbl
                end
        recommendation_parse1(node, out, label)
      end

      def permission_parse(node, out)
        label = case node["type"]
                when "verification" then @labels["permissiontest"]
                when "class" then @labels["permissionclass"]
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

      def sequential_permission_children(t, id)
        sequential_permission_names1(t, id, "permission[not(@type = 'verification' or @type = 'class')]", @permission_lbl)
        sequential_permission_names1(t, id, "requirement[not(@type = 'verification' or @type = 'class')]", @requirement_lbl)
        sequential_permission_names1(t, id, "recommendation[not(@type = 'verification' or @type = 'class')]", @recommendation_lbl)
        sequential_permission_names1(t, id, "permission[@type = 'verification']", @labels["permissiontest"])
        sequential_permission_names1(t, id, "requirement[@type = 'verification']", @labels["requirementtest"])
        sequential_permission_names1(t, id, "recommendation[@type = 'verification']", @labels["recommendationtest"])
        sequential_permission_names1(t, id, "permission[@type = 'class']", @labels["permissionclass"])
        sequential_permission_names1(t, id, "requirement[@type = 'class']", @labels["requirementclass"])
        sequential_permission_names1(t, id, "recommendation[@type = 'class']", @labels["recommendationclass"])
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
        sequential_permission_names(clause, "permission[not(@type = 'verification' or @type = 'class')]", @permission_lbl)
        sequential_permission_names(clause, "requirement[not(@type = 'verification' or @type = 'class')]", @requirement_lbl)
        sequential_permission_names(clause, "recommendation[not(@type = 'verification' or @type = 'class')]", @recommendation_lbl)
        sequential_permission_names(clause, "permission[@type = 'verification']", @labels["permissiontest"])
        sequential_permission_names(clause, "requirement[@type = 'verification']", @labels["requirementtest"])
        sequential_permission_names(clause, "recommendation[@type = 'verification']", @labels["recommendationtest"])
        sequential_permission_names(clause, "permission[@type = 'class']", @labels["permissionclass"])
        sequential_permission_names(clause, "requirement[@type = 'class']", @labels["requirementclass"])
        sequential_permission_names(clause, "recommendation[@type = 'class']", @labels["recommendationclass"])
      end

      def hierarchical_asset_names(clause, num)
        hierarchical_table_names(clause, num)
        hierarchical_figure_names(clause, num)
        hierarchical_formula_names(clause, num)
        hierarchical_permission_names(clause, num, "permission[not(@type = 'verification' or @type = 'class')]", @permission_lbl)
        hierarchical_permission_names(clause, num, "requirement[not(@type = 'verification' or @type = 'class')]", @requirement_lbl)
        hierarchical_permission_names(clause, num, "recommendation[not(@type = 'verification' or @type = 'class')]", @recommendation_lbl)
        hierarchical_permission_names(clause, num, "permission[@type = 'verification']", @labels["permissiontest"])
        hierarchical_permission_names(clause, num, "requirement[@type = 'verification']", @labels["requirementtest"])
        hierarchical_permission_names(clause, num, "recommendation[@type = 'verification']", @labels["recommendationtest"])
        hierarchical_permission_names(clause, num, "permission[@type = 'class']", @labels["permissionclass"])
        hierarchical_permission_names(clause, num, "requirement[@type = 'class']", @labels["requirementclass"])
        hierarchical_permission_names(clause, num, "recommendation[@type = 'class']", @labels["recommendationclass"])
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
