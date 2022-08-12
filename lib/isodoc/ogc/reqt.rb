require_relative "reqt_helper"

module IsoDoc
  module Ogc
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def recommendation1(elem, _type)
        type = recommendation_class_label(elem)
        label = elem.at(ns("./identifier"))&.text
        if inject_crossreference_reqt?(elem, label)
          n = @xrefs.anchor(@xrefs.reqtlabels[label], :xref, false)
          lbl = (n.nil? ? type : n)
          elem&.at(ns("./title"))&.remove # suppress from display if embedded
        else
          n = @xrefs.anchor(elem["id"], :label, false)
          lbl = (n.nil? ? type : l10n("#{type} #{n}"))
        end
        prefix_name(elem, "", lbl, "name")
      end

      # embedded reqts xref to top level reqts via label lookup
      def inject_crossreference_reqt?(node, label)
        !node.ancestors("requirement, recommendation, permission").empty? &&
          @xrefs.reqtlabels[label]
      end

      def recommendation_header(recommend, out)
        h = out.add_child("<thead><tr><th scope='colgroup' colspan='2'>"\
                          "</th></tr></thead>").first
        recommendation_name(recommend, h.at(".//th"))
      end

      def recommendation_name(node, out)
        b = out.add_child("<p class='#{recommend_name_class(node)}'></p>").first
        name = node.at(ns("./name")) and name.children.each { |n| b << n }
        return unless title = node.at(ns("./title"))

        b << l10n(": ") if name
        title.children.each { |n| b << n }
      end

      def recommend_title(node, out)
        label = node.at(ns("./identifier")) or return
        b = out.add_child("<tr><td colspan='2'><p></p></td></tr>")
        p = b.at(".//p")
        p["class"] = "RecommendationLabel"
        p << label.children.to_xml
      end

      def recommendation_attributes1(node)
        ret = recommendation_attributes1_head(node, [])
        node.xpath(ns("./classification")).each do |c|
          line = recommendation_attr_keyvalue(c, "tag",
                                              "value") and ret << line
        end
        ret
      end

      def recommendation_attributes1_head(node, head)
        oblig = node["obligation"] and head << ["Obligation", oblig]
        subj = node.at(ns("./subject"))&.children and
          head << [rec_subj(node), subj]
        node.xpath(ns("./classification[tag = 'target']/value")).each do |v|
          xref = recommendation_id(v.text) and head << [rec_target(node), xref]
        end
        %w(general class).include?(node["type"]) and
          xref = recommendation_link(node.at(ns("./identifier"))&.text) and
          head << ["Conformance test", xref]
        recommendation_attributes1_dependencies(node, head)
      end

      def recommendation_attributes1_dependencies(node, head)
        node.xpath(ns("./inherit")).each do |i|
          head << ["Dependency", recommendation_id(i.children.to_xml)]
        end
        node.xpath(ns("./classification[tag = 'indirect-dependency']/value"))
          .each do |v|
          xref = recommendation_id(v.children.to_xml) and
            head << ["Indirect Dependency", xref]
        end
        head
      end

      def recommendation_steps(node)
        node.elements.each { |e| recommendation_steps(e) }
        return node unless node.at(ns("./component[@class = 'step']"))

        d = node.at(ns("./component[@class = 'step']"))
        d = d.replace("<ol class='steps'><li>#{d.children.to_xml}</li></ol>")
          .first
        node.xpath(ns("./component[@class = 'step']")).each do |f|
          f = f.replace("<li>#{f.children.to_xml}</li>").first
          d << f
        end
        node
      end

      def recommendation_attributes1_component(node, out)
        node = recommendation_steps(node)
        out << "<tr><td>#{node['label']}</td><td>#{node.children}</td></tr>"
      end

      def recommendation_attr_keyvalue(node, key, value)
        tag = node.at(ns("./#{key}"))
        value = node.at(ns("./#{value}"))
        (tag && value && !%w(target indirect-dependency).include?(tag.text)) or
          return nil
        [tag.text.capitalize, value.children]
      end

      def recommendation_attributes(node, out)
        recommend_title(node, out)
        recommendation_attributes1(node).each do |i|
          out.add_child("<tr><td>#{i[0]}</td><td>#{i[1]}</td></tr>")
        end
      end

      def preserve_in_nested_table?(node)
        %w(recommendation requirement permission
           table ol dl ul).include?(node.name)
      end

      def requirement_component_parse(node, out)
        return if node["exclude"] == "true"

        node.elements.size == 1 && node.first_element_child.name == "dl" and
          return reqt_dl(node.first_element_child, out)
        node.name == "component" and
          return recommendation_attributes1_component(node, out)
        b = out.add_child("<tr><td colspan='2'></td></tr>").first
        b.at(".//td") <<
          (preserve_in_nested_table?(node) ? node : node.children)
      end

      def reqt_dl(node, out)
        node.xpath(ns("./dt")).each do |dt|
          dd = dt.next_element
          dd&.name == "dd" or next
          out.add_child("<tr><td>#{dt.children.to_xml}</td>"\
                        "<td>#{dd.children.to_xml}</td></tr>")
        end
      end

      def recommendation_base(node, klass)
        out = node.document.create_element("table")
        out["id"] = node["id"]
        %w(keep-with-next keep-lines-together unnumbered).each do |x|
          out[x] = node[x] if node[x]
        end
        out["class"] = klass
        out["type"] = recommend_class(node)
        recommendation_component_labels(node)
        out
      end

      def recommendation_component_labels(node)
        node.xpath(ns("./component[@class = 'part']")).each_with_index do |c, i|
          c["label"] = (i + "A".ord).chr.to_s
        end
        node.xpath(ns("./component[not(@class = 'part')]")).each do |c|
          c["label"] = case c["class"]
                       when "test-purpose" then "Test purpose"
                       when "test-method" then "Test method"
                       else Metanorma::Utils.strict_capitalize_first(c["class"])
                       end
        end
      end

      def recommendation_parse1(node, klass)
        out = recommendation_base(node, klass)
        recommendation_header(node, out)
        b = out.add_child("<tbody></tbody>").first
        recommendation_attributes(node, b)
        node.elements.reject do |n|
          %w(classification subject name identifier title
             inherit).include?(n.name)
        end.each { |n| requirement_component_parse(n, b) }
        node.replace(out)
      end

      REQS = %w(recommendation requirement permission).freeze

      def recommendation_to_table(docxml)
        @reqt_links = reqt_links(docxml)
        @reqt_ids = reqt_ids(docxml)
        REQS.each do |x|
          REQS.each do |y|
            docxml.xpath(ns("//#{x}//#{y}")).each do |r|
              recommendation_parse1(r, y)
            end
          end
          docxml.xpath(ns("//#{x}")).each do |r|
            recommendation_parse1(r, x)
          end
        end
        requirement_table_cleanup(docxml)
      end

      # table nested in table: merge label and caption into a single row
      def requirement_table_cleanup1(outer, inner)
        outer.delete("colspan")
        outer.delete("scope")
        inner.delete("colspan")
        inner.delete("scope")
        outer.name = "td"
        p = outer.at(ns("./p[@class = 'RecommendationTitle']")) and
          p.delete("class")
        outer.parent << inner.dup
        inner.parent.remove
      end

      def requirement_table_cleanup(docxml)
        docxml.xpath(ns("//table[@type = 'recommendclass']/tbody/tr/td/table"))
          .each do |t|
          t.xpath(ns("./thead | ./tbody |./tfoot")).each do |x|
            x.replace(x.children)
          end
          (x = t.at(ns("./tr/th[@colspan = '2']"))) &&
            (y = t.at(ns("./tr/td[@colspan = '2']"))) and
            requirement_table_cleanup1(x, y)
          t.parent.parent.replace(t.children)
        end
      end
    end
  end
end
