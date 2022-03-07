require "isodoc"
require_relative "biblio"
require_relative "sections"
require "fileutils"

module IsoDoc
  module Ogc
    module BaseConvert
      def error_parse(node, out)
        case node.name
        when "hi" then hi_parse(node, out)
        else
          super
        end
      end

      def hi_parse(node, out)
        out.span **{ class: "hi" } do |e|
          node.children.each { |n| parse(n, e) }
        end
      end

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
        term.children.first.previous = "&#xa0;"
        term.children.first.previous = h2.remove.children
      end

      def term_cleanup_merge_admitted(term)
        term.xpath("./following-sibling::p[@class = 'AltTerms' or "\
                   "@class = 'DeprecatedTerms']").each do |a|
          term << " "
          term << a.children
          a.remove
        end
      end

      def deprecated_term_parse(node, out)
        out.p **{ class: "DeprecatedTerms" } do |p|
          node.children.each { |c| parse(c, p) }
          p << "&#xa0;"
          p.span **{ class: "AdmittedLabel" } do |s|
            s << l10n(@i18n.deprecated)
          end
        end
      end

      def admitted_term_parse(node, out)
        out.p **{ class: "AltTerms" } do |p|
          node.children.each { |c| parse(c, p) }
          p << "&#xa0;"
          p.span **{ class: "AdmittedLabel" } do |s|
            s << l10n(@i18n.admitted)
          end
        end
      end

      def example_parse(node, out)
        name = node.at(ns("./name"))
        example_name_parse(node, out, name) # if name
        super
      end

      def example_label(node, div, name); end

      def example_name_parse(_node, div, name)
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

      def make_tr_attr(cell, row, totalrows, header)
        ret = super
        if cell.at("./ancestor::xmlns:table[@class = 'recommendation'] | "\
                   "./ancestor::xmlns:table[@class = 'requirement'] | "\
                   "./ancestor::xmlns:table[@class = 'permission']")
          ret[:style] = "vertical-align:top;"
          ret[:class] = "recommend"
        end
        ret
      end

      def para_class(node)
        return node["class"] if node["class"] &&
          node["class"] != "RecommendationLabel"

        super
      end

      def ol_depth(node)
        return super unless (node["class"] == "steps") ||
          node.at(".//ancestor::xmlns:ol[@class = 'steps']")

        idx = node.xpath("./ancestor-or-self::xmlns:ol[@class = 'steps']").size
        styles = %i(arabic alphabet roman alphabet_upper roman_upper)
        ol_style(styles[(idx - 1) % 5])
      end
    end
  end
end
