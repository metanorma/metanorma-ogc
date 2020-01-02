require "isodoc"
require_relative "metadata"
require "fileutils"

module IsoDoc
  module Ogc
    module BaseConvert
      def recommend_table_attr(node)
        attr_code(id: node["id"], class: "recommend",
                  style: "border-collapse:collapse;border-spacing:0;" )
      end

      REQ_TBL_ATTR =
        { class: "example_label",
          style: "width:100.0pt;padding:0 0 0 1em;margin-left:0pt;vertical-align:top;" }.freeze

      def recommendation_name(node, out, type)
        out.p **{ class: "RecommendationTitle" }  do |b|
          lbl = anchor(node['id'], :label, false)
          b << (lbl.nil? ? l10n("#{type}:") : l10n("#{type} #{lbl}:"))
        end
      end

      def recommend_title(node, div)
        label = node.at(ns("./label"))
        title = node.at(ns("./title"))
        label || title or return
        div.p do |p|
          p.b do |b|
            label and label.children.each { |n| parse(n,b) }
            b << "#{clausedelim} " if label && title
            title and title.children.each { |n| parse(n,b) }
          end
        end
      end

      def recommendation_body(node, tr)
        tr.td **{ style: "vertical-align:top;", class: "recommend" } do |td|
          recommend_title(node, td)
          node.children.each do |n|
            parse(n, td) unless %(label title).include?(n.name)
          end
        end
      end

      def recommendation_parse(node, out)
        out.table **recommend_table_attr(node) do |t|
          t.tr do |tr|
            tr.td **REQ_TBL_ATTR do |td|
              recommendation_name(node, td, @recommendation_lbl)
            end
            recommendation_body(node, tr)
          end
        end
      end

      def requirement_parse(node, out)
        out.table **recommend_table_attr(node) do |t|
          t.tr do |tr|
            tr.td **REQ_TBL_ATTR do |td|
              recommendation_name(node, td, @requirement_lbl)
            end
            recommendation_body(node, tr)
          end
        end
      end

      def permission_parse(node, out)
        out.table **recommend_table_attr(node) do |t|
          t.tr do |tr|
            tr.td **REQ_TBL_ATTR do |td|
              recommendation_name(node, td, @permission_lbl)
            end
            recommendation_body(node, tr)
          end
        end
      end
    end
  end
end
