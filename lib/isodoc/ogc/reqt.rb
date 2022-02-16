require "isodoc"
require "metanorma-utils"

module IsoDoc
  module Ogc
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def recommend_class(node)
        return "recommendtest" if node["type"] == "verification"
        return "recommendtest" if node["type"] == "abstracttest"
        return "recommendclass" if node["type"] == "class"
        return "recommendclass" if node["type"] == "conformanceclass"

        "recommend"
      end

      def recommend_class?(node)
        %w(recommendtest recommendclass recommend).include? node["type"]
      end

      def recommendation_class(node)
        if node["type"] == "recommendtest"
          "RecommendationTestTitle"
        else
          "RecommendationTitle"
        end
      end

      def recommendation_header(recommend)
        h = recommend.add_child("<thead><tr><th scope='colgroup' colspan='2'>"\
                                "</th></tr></thead>")
        recommendation_name(recommend, h.at(ns(".//th")))
      end

      def recommendation_name(node, out)
        b = out.add_child("<p class='#{recommendation_class(node)}'></p>").first
        name = node&.at(ns("./name"))&.remove and
          name.children.each { |n| b << n }
        if title = node&.at(ns("./title"))&.remove
          b << l10n(": ") if name
          title.children.each { |n| b << n }
        end
      end

      def recommend_title(node, out)
        label = node&.at(ns("./label"))&.remove or return
        label.xpath(ns(".//xref | .//eref | .//quote/source"))
          .each { |f| xref1(f) }
        label.xpath(ns(".//concept")).each { |f| concept1(f) }
        b = out.add_child("<tr><td colspan='2'><p></p></td></tr>")
        p = b.at(ns(".//p"))
        p["class"] = "RecommendationLabel"
        p << label.children.to_xml
      end

      def recommendation_attributes1(node)
        out = recommendation_attributes1_head(node, [])
        node.xpath(ns("./classification")).each do |c|
          line = recommendation_attr_keyvalue(c, "tag", "value") and out << line
        end
        out
      end

      def recommendation_attributes1_head(node, out)
        oblig = node["obligation"] and out << ["Obligation", oblig]
        subj = node&.at(ns("./subject"))&.remove&.children and
          out << [rec_subj(node), subj]
        %w(general class).include?(node["type_original"]) and
          test = @reqt_links[node["id"]] and
          out << ["Conformance test", "<xref target='#{test}'/>"]
        node.xpath(ns("./inherit")).each do |i|
          out << ["Dependency", i.remove.children]
        end
        out
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

      def rec_subj(node)
        case node["type_original"]
        when "class" then "Target type"
        when "conformanceclass" then "Requirements class"
        when "verification", "abstracttest" then "Requirement"
        else "Subject"
        end
      end

      def recommendation_attr_keyvalue(node, key, value)
        tag = node&.at(ns("./#{key}"))&.remove
        value = node.at(ns("./#{value}"))&.remove
        (tag && value) or return nil
        node.remove
        [tag.text.capitalize, value.children]
      end

      def recommendation_attributes(node, out)
        recommend_title(node, out)
        recommendation_attributes1(node).each do |i|
          out.add_child("<tr><td>#{i[0]}</td><td>#{i[1]}</td></tr>")
        end
      end

      def preserve_in_nested_table?(node)
        return true if %w(recommendation requirement permission
                          table ol dl ul).include?(node.name)

        false
      end

      def requirement_component_parse(node, out)
        node.remove
        return if node["exclude"] == "true"

        node.elements.size == 1 && node.first_element_child.name == "dl" and
          return reqt_dl(node.first_element_child, out)
        node.name == "component" and
          return recommendation_attributes1_component(node, out)
        b = out.add_child("<tr><td colspan='2'></td></tr>").first
        b.at(ns(".//td")) <<
          (preserve_in_nested_table?(node) ? node : node.children)
      end

      def reqt_dl(node, out)
        node.xpath(ns("./dt")).each do |dt|
          dd = dt&.next_element
          dt.remove
          dd&.name == "dd" or next
          b = out.add_child("<tr><td></td><td></td></tr>")
          b.at(ns(".//td[1]")) << dt.children
          b.at(ns(".//td[2]")) << dd.remove.children
        end
      end

      def recommendation_base(node, klass)
        node.name = "table"
        node["class"] = klass
        node["type_original"] = node["type"]
        node["type"] = recommend_class(node)
        recommendation_component_labels(node)
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
        recommendation_base(node, klass)
        recommendation_header(node)
        b = node.add_child("<tbody></tbody>").first
        recommendation_attributes(node, b)
        node.elements.reject do |n|
          %w(thead tbody classification subject
             inherit).include?(n.name)
        end.each { |n| requirement_component_parse(n, b) }
        node.delete("type_original")
      end

      def recommendation_to_table(docxml)
        @reqt_links = reqt_links(docxml)
        docxml.xpath(ns("//recommendation")).each do |r|
          recommendation_parse1(r, "recommendation")
        end
        docxml.xpath(ns("//requirement")).each do |r|
          recommendation_parse1(r, "requirement")
        end
        docxml.xpath(ns("//permission")).each do |r|
          recommendation_parse1(r, "permission")
        end
        requirement_table_cleanup(docxml)
      end

      def reqt_links(docxml)
        docxml.xpath(ns("//requirement | //recommendation | //permission"))
          .each_with_object({}) do |r, m|
            next unless %w(conformanceclass verification).include?(r["type"])
            next unless subject = r&.at(ns("./subject/xref/@target"))&.text

            m[subject] = r["id"]
          end
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
