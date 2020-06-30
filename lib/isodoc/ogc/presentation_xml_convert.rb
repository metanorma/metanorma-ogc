require_relative "init"
require "isodoc"

module IsoDoc
  module Ogc
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def example1(f)
        lbl = @xrefs.anchor(f['id'], :label, false) or return
        prefix_name(f, "&nbsp;&mdash; ", l10n("#{@example_lbl} #{lbl}"), "name")
      end

      def recommendation1(f, type)
        type = recommendation_class(f)
        label = f&.at(ns("./label"))&.text
        if inject_crossreference_reqt?(f, label)
          n = @xrefs.anchor(@xrefs.reqtlabels[label], :xref, false)
          lbl = (n.nil? ? type : n)
          f&.at(ns("./title"))&.remove # suppress from display if embedded
        else
          n = @xrefs.anchor(f['id'], :label, false)
          lbl = (n.nil? ? type : l10n("#{type} #{n}"))
        end
        prefix_name(f, "", lbl, "name")
      end

      # embedded reqts xref to top level reqts via label lookup
      def inject_crossreference_reqt?(node, label)
        !node.ancestors("requirement, recommendation, permission").empty? &&
          @xrefs.reqtlabels[label]
      end

      def recommendation_class(node)
        case node["type"]
        when "verification" then @labels["#{node.name}test"]
        when "class" then @labels["#{node.name}class"]
        when "abstracttest" then @labels["abstracttest"]
        when "conformanceclass" then @labels["conformanceclass"]
        else
          case node.name
          when "recommendation" then @recommendation_lbl
          when "requirement" then @requirement_lbl
          when "permission" then @permission_lbl
          end
        end
      end

      include Init
    end
  end
end

