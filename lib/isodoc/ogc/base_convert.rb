require "isodoc"
require_relative "reqt"
require_relative "biblio"
require_relative "sections"
require "fileutils"

module IsoDoc
  module Ogc
    module BaseConvert
      def fileloc(loc)
        File.join(File.dirname(__FILE__), loc)
      end

      def cleanup(docxml)
        requirement_table_cleanup(docxml)
        super
        term_cleanup(docxml)
      end

      # table nested in table: merge label and caption into a single row
      def requirement_table_cleanup(docxml)
        docxml.xpath("//table[@class = 'recommendclass']//table").each do |t|
          x = t.at("./thead") and x.replace(x.children)
          x = t.at("./tbody") and x.replace(x.children)
          x = t.at("./tfoot") and x.replace(x.children)
          if x = t.at("./tr/th[@colspan = '2']") and
              y = t.at("./tr/td[@colspan = '2']")
            x["colspan"] = "1"
            y["colspan"] = "1"
            x.name = "td"
            p = x.at("./p[@class = 'RecommendationTitle']") and
              p.delete("class")
            x << y.dup
            y.parent.remove
          end
          t.replace(t.children)
        end
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

      def middle_clause
        "//clause[parent::sections][not(xmlns:title = 'Scope' or "\
        "xmlns:title = 'Conformance')][not(descendant::terms)]"
      end

      def middle(isoxml, out)
        middle_title(out)
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
    end
  end
end
