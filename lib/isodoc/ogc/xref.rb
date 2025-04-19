module IsoDoc
  module Ogc
    class Counter < IsoDoc::XrefGen::Counter
    end

    class Xref < IsoDoc::Xref
      def clause_order_main(docxml)
        ret = [{ path: "//clause[@type = 'scope']" },
               { path: "//clause[@type = 'conformance']" },
               { path: @klass.norm_ref_xpath }]
        a = ["//sections/terms | //sections/clause[descendant::terms]",
             "//sections/definitions | " \
             "//sections/clause[descendant::definitions][not(descendant::terms)]",
             @klass.middle_clause(docxml)]
        ret + if @doctype == "engineering-report"
                [{ path: a.join(" | "), multi: true }]
              else
                [{ path: a[0] }, { path: a[1] }, { path: a[2], multi: true }]
              end
      end

      def clause_order_annex(_docxml)
        if  @doctype == "engineering-report"
          [
            { path: @klass.bibliography_xpath },
            { path: "//annex", multi: true },
          ]
        else super
        end
      end

      def clause_order_back(_docxml)
        if @doctype == "engineering-report"
          [
            { path: "//indexsect", multi: true },
            { path: "//colophon/*", multi: true },
          ]
        else super
        end
      end

      def middle_section_asset_names(doc)
        middle_sections =
          "//clause[@type = 'scope' or @type = 'conformance'] | //foreword | " \
          "//introduction | //preface/abstract | " \
          "//acknowledgements | //preface/clause | " \
          "#{@klass.norm_ref_xpath} | //sections/terms | " \
          "//sections/definitions | //clause[parent::sections]"
        sequential_asset_names(doc.xpath(ns(middle_sections)))
      end

      def preface_anchor_names(xml)
        @prefacenum = 0
        super
      end

      def preface_names(clause)
        clause.nil? || clause["type"] == "toc" and return
        @prefacenum += 1
        pref = semx(clause, preface_number(@prefacenum, 1))
        @anchors[clause["id"]] =
          { label: pref, level: 1,  type: "clause",
            xref: semx(clause, clause_title(clause), "title") }
        clause.xpath(ns(SUBCLAUSES)).each_with_index do |c, i|
          preface_names_numbered1(c, pref, preface_number(i + 1, 2), 2)
        end
      end

      def preface_names_numbered1(clause, parentnum, num, level)
        lbl = clause_number_semx(parentnum, clause, num)
        @anchors[clause["id"]] =
          { label: lbl, level: level,
            xref: labelled_autonum(@labels["clause"], lbl),
            type: "clause", elem: @labels["clause"] }
        clause.xpath(ns(SUBCLAUSES)).each_with_index do |c, i|
          preface_names_numbered1(c, lbl, preface_number(i + 1, level + 1),
                                  level + 1)
        end
      end

      def preface_number(num, level)
        case level
        when 1 then RomanNumerals.to_roman(num).upcase
        when 2 then (64 + num).chr.to_s
        when 3 then num.to_s
        when 4 then (96 + num).chr.to_s
        when 5 then RomanNumerals.to_roman(num).downcase
        when 6 then "(#{num})"
        when 7 then "(#{(96 + num).chr})"
        when 8 then "(#{RomanNumerals.to_roman(num).downcase})"
        else num.to_s
        end
      end

      FIGURE_NO_CLASS = ".//figure[not(@class)]".freeze

      LISTING = <<~XPATH.freeze
        .//figure[@class = 'pseudocode'] | .//sourcecode[not(ancestor::example)]
      XPATH

      def sequential_asset_names(clause, container: false)
        super
        sequential_sourcecode_names(clause, container: container)
      end

      def sequential_sourcecode_names(clause, container: false)
        c = Counter.new
        clause.xpath(ns(LISTING)).noblank.each do |t|
          c.increment(t)
          @anchors[t["id"]] = anchor_struct(
            c.print, t,
            @labels["sourcecode"], "sourcecode",
            { unnumb: t["unnumbered"], container: container }
          )
        end
      end

      def hierarchical_asset_names(clause, num)
        super
        hierarchical_sourcecode_names(clause, num)
      end

      def hierarchical_sourcecode_names(clauses, num)
        c = Counter.new
        nodeSet(clauses).each do |clause|
          clause.xpath(ns(LISTING)).noblank.each do |t|
            @anchors[t["id"]] =
              anchor_struct(hiersemx(clause, num, c.increment(t), t),
                            t, @labels["sourcecode"],
                            "sourcecode", { unnumb: t["unnumbered"] })
          end
        end
      end
    end
  end
end
