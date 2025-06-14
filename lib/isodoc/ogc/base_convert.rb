require "isodoc"
require_relative "sections"
require "fileutils"

module IsoDoc
  module Ogc
    module BaseConvert
      def cleanup(docxml)
        super
        term_cleanup(docxml)
      end

      def term_cleanup(docxml)
        docxml.xpath("//p[@class = 'Terms']").each do |d|
          term_cleanup_merge_termnum(d)
          # term_cleanup_merge_admitted(d)
        end
        docxml
      end

      def term_cleanup_merge_termnum(term)
        h2 = term.at("./preceding-sibling::*[@class = 'TermNum'][1]")
        term["class"] = h2["class"]
        term["id"] = h2["id"]
        # TODO to PresentationXML
        term.add_first_child "&#xa0;"
        term.add_first_child h2.remove.children
      end

      def term_cleanup_merge_admitted(term)
        term.xpath("./following-sibling::p[@class = 'AltTerms' or " \
                   "@class = 'DeprecatedTerms']").each do |a|
          term << " "
          term << a.children
          a.remove
        end
      end

      def example_parse(node, out)
        name = node.at(ns("./fmt-name"))
        example_name_parse(node, out, name) # if name
        super
      end

      def example_label(node, div, name); end

      def example_name_parse(_node, div, name)
        div.p class: "SourceTitle", style: "text-align:center;" do |p|
          name&.children&.each { |n| parse(n, p) }
        end
      end

      def middle_clause(_docxml)
        "//clause[parent::sections][not(@type = 'scope' or " \
          "@type = 'conformance')][not(descendant::terms)]" \
          "[not(descendant::references)]"
      end

      def table_attrs(node)
        ret = super
        %w(recommendation requirement permission).include?(node["class"]) and
          ret = ret.merge(class: node["type"], style:
                          "border-collapse:collapse;border-spacing:0;" \
                          "#{keep_style(node)}")
        ret
      end

      def make_tr_attr(cell, row, totalrows, header, bordered)
        ret = super
        if cell.at("./ancestor::xmlns:table[@class = 'recommendation'] | " \
                   "./ancestor::xmlns:table[@class = 'requirement'] | " \
                   "./ancestor::xmlns:table[@class = 'permission']")
          ret[:style] = "vertical-align:top;#{ret['style']}"
          ret[:class] = "recommend"
        end
        ret
      end

      def para_class(node)
        if node["class"] == "RecommendationLabel"
          node["class"] = nil
          ret = super
          node["class"] = "RecommendationLabel"
          ret
        else super
        end
      end
    end
  end
end
