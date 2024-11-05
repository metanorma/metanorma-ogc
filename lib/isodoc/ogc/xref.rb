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
          "//introduction | //preface/abstract | //submitters | " \
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
        clause.nil? and return
        clause["type"] == "toc" and return
        @prefacenum += 1
        pref = preface_number(@prefacenum, 1)
        @anchors[clause["id"]] =
          { label: pref,
            level: 1, xref: clause_title(clause), type: "clause" }
        clause.xpath(ns(SUBCLAUSES)).each_with_index do |c, i|
          preface_names_numbered1(c, "#{pref}.#{preface_number(i + 1, 2)}", 2)
        end
      end

      def preface_names_numbered1(clause, num, level)
        @anchors[clause["id"]] =
          { label: num, level: level, xref: l10n("#{@labels['clause']} #{num}"),
            type: "clause", elem: @labels["clause"] }
        clause.xpath(ns(SUBCLAUSES)).each_with_index do |c, i|
          lbl = "#{num}.#{preface_number(i + 1, level + 1)}"
          preface_names_numbered1(c, lbl, level + 1)
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

      def sequential_permission_body(id, block, label, klass, model,
container: false)
        @anchors[block["id"]] = model.postprocess_anchor_struct(
          block, anchor_struct(id, container ? block : nil,
                               label, klass, block["unnumbered"])
        )
        model.permission_parts(block, id, label, klass).each do |n|
          @anchors[n[:id]] = anchor_struct(n[:number], nil, n[:label],
                                           n[:klass], false)
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
            c.print, container ? t : nil,
            @labels["sourcecode"], "sourcecode",
            t["unnumbered"]
          )
        end
      end

      def hierarchical_asset_names(clause, num)
        super
        hierarchical_sourcecode_names(clause, num)
      end

      def hierarchical_sourcecode_names(clause, num)
        c = Counter.new
        clause.xpath(ns(LISTING)).noblank.each do |t|
          c.increment(t)
          label = "#{num}#{hiersep}#{c.print}"
          @anchors[t["id"]] =
            anchor_struct(label, nil, @labels["sourcecode"],
                          "sourcecode", t["unnumbered"])
        end
      end
    end
  end
end
