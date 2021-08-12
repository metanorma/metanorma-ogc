require "isodoc"

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
        if name = node&.at(ns("./name"))&.remove
          name.children.each { |n| b << n }
          b << l10n(":")
        end
        if title = node&.at(ns("./title"))&.remove
          b << l10n(" ") if name
          title.children.each { |n| b << n }
        end
      end

      def recommend_title(node, out)
        label = node&.at(ns("./label"))&.remove or return
        b = out.add_child("<tr><td colspan='2'><p></p></td></tr>")
        p = b.at(ns(".//p"))
        p << label.children
      end

      def recommendation_attributes1(node)
        out = recommendation_attributes1_head(node, [])
        out = recommendation_attributes1_component(node, out)
        node.xpath(ns("./classification")).each do |c|
          line = recommendation_attr_keyvalue(c, "tag", "value") and out << line
        end
        out
      end

      def recommendation_attributes1_head(node, out)
        oblig = node["obligation"] and out << ["Obligation", oblig]
        subj = node&.at(ns("./subject"))&.remove&.children and
          out << [rec_subj(node), subj]
        node.xpath(ns("./inherit")).each do |i|
          out << ["Dependency", i.remove.children]
        end
        out
      end

      def strict_capitalize_phrase(str)
        str.split(/ /).map do |w|
          letters = w.chars
          letters.first.upcase!
          letters.join
        end.join(" ")
      end

      def recommendation_attributes1_component(node, out)
        node.xpath(ns("./component[not(@class = 'part')]")).each do |c|
          out << case c["class"]
                 when "test-purpose" then ["Test Purpose", c.remove.children]
                 when "test-method" then ["Test Method", c.remove.children]
                 else [strict_capitalize_phrase(c["class"]), c.remove.children]
                 end
        end
        node.xpath(ns("./component[@class = 'part']")).each_with_index do |c, i|
          out << [(i + "A".ord).chr.to_s, c.remove.children]
        end
        out
      end

      def rec_subj(node)
        node["type"] == "recommendclass" ? "Target Type" : "Subject"
      end

      def recommendation_attr_keyvalue(node, key, value)
        tag = node&.at(ns("./#{key}"))&.remove
        value = node.at(ns("./#{value}"))&.remove
        tag && value or return nil
        node.remove
        [tag.text.capitalize, value.children]
      end

      def recommendation_attributes(node, out)
        recommendation_attributes1(node).each do |i|
          out.add_child("<tr><td>#{i[0]}</td><td>#{i[1]}</td></tr>")
        end
      end

      def preserve_in_nested_table?(node)
        return true if %w(recommendation requirement permission
                          table).include?(node.name)

        false
      end

      def requirement_component_parse(node, out)
        node.remove
        return if node["exclude"] == "true"

        node.elements.size == 1 && node.first_element_child.name == "dl" and
          return reqt_dl(node.first_element_child, out)
        b = out.add_child("<tr><td colspan='2'></td></tr>").first
        b.at(ns(".//td")) << (preserve_in_nested_table?(node) ? node : node.children)
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
        node["type"] = recommend_class(node)
      end

      def recommendation_parse1(node, klass)
        recommendation_base(node, klass)
        recommendation_header(node)
        b = node.add_child("<tbody></tbody>").first
        recommend_title(node, b)
        recommendation_attributes(node, b)
        node.elements.each do |n|
          next if %w(thead tbody).include?(n.name)

          requirement_component_parse(n, b)
        end
      end

      def recommendation_to_table(docxml)
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

      # table nested in table: merge label and caption into a single row
      def requirement_table_cleanup1(x, y)
        x.delete("colspan")
        x.delete("scope")
        y.delete("colspan")
        y.delete("scope")
        x.name = "td"
        p = x.at(ns("./p[@class = 'RecommendationTitle']")) and
          p.delete("class")
        x.parent << y.dup
        y.parent.remove
      end

      def requirement_table_cleanup(docxml)
        docxml.xpath(ns("//table[@type = 'recommendclass']/tbody/tr/td/table")).each do |t|
          x = t.at(ns("./thead")) and x.replace(x.children)
          x = t.at(ns("./tbody")) and x.replace(x.children)
          x = t.at(ns("./tfoot")) and x.replace(x.children)
          if (x = t.at(ns("./tr/th[@colspan = '2']"))) &&
              (y = t.at(ns("./tr/td[@colspan = '2']")))
            requirement_table_cleanup1(x, y)
          end
          t.parent.parent.replace(t.children)
        end
      end
    end
  end
end
