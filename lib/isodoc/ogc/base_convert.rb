require "isodoc"
require_relative "biblio"
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
          h2 = d.at("./preceding-sibling::*[@class = 'TermNum'][1]")
          h2.add_child("&nbsp;")
          h2.add_child(d.remove)
        end
        docxml
      end

      def example_parse(node, out)
        name = node.at(ns("./name"))
        example_name_parse(node, out, name) #if name
        super
      end

      def example_label(node, div, name)
      end

      def example_name_parse(node, div, name)
        div.p **{ class: "SourceTitle", style: "text-align:center;" } do |p|
          name&.children&.each { |n| parse(n, p) }
        end
      end

      def middle_clause(_docxml)
        "//clause[parent::sections][not(@type = 'scope' or "\
        "@type = 'conformance')][not(descendant::terms)]"
      end

      def is_clause?(name)
        return true if name == "submitters"
        super
      end

      def middle(isoxml, out)
        middle_title(isoxml, out)
        middle_admonitions(isoxml, out)
        i = scope isoxml, out, 0
        i = conformance isoxml, out, i
        i = norm_ref isoxml, out, i
        i = terms_defs isoxml, out, i
        i = symbols_abbrevs isoxml, out, i
        clause isoxml, out
        annex isoxml, out
        bibliography isoxml, out
      end

      def table_attrs(node)
        ret = super
        %w(recommendation requirement permission).include?(node["class"]) and
          ret = ret.merge(class: node["type"], style:
                          "border-collapse:collapse;border-spacing:0;"\
                          "#{keep_style(node)}")
        ret
      end

      def make_tr_attr(td, row, totalrows, header)
        ret = super
        if td.at("./ancestor::xmlns:table[@class = 'recommendation'] | "\
            "./ancestor::xmlns:table[@class = 'requirement'] | "\
            "./ancestor::xmlns:table[@class = 'permission']")
          ret[:style] = "vertical-align:top;"
          ret[:class] = "recommend"
        end
        ret
      end

      def para_class(node)
        return node["class"] if node["class"]
        super
      end
    end
  end
end
