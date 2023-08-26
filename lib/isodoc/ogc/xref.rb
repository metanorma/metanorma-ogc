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
        ret + if docxml.at(ns("//bibdata/ext/doctype"))&.text == "engineering-report"
                [{ path: a.join(" | "), multi: true }]
              else
                [{ path: a[0] }, { path: a[1] }, { path: a[2], multi: true }]
              end
      end

      # ["//preface/abstract", "//preface/clause[@type = 'executivesummary']", "//preface/clause[@type = 'keywords']", "//foreword", "//preface/clause[@type = 'security']", "//preface/clause[@type = 'submitting_orgs']", "//submitters", "//introduction"]

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

      def reference_names(ref)
        super
        return unless @klass.ogc_draft_ref?(ref)

        @anchors[ref["id"]] = { xref: "#{@anchors[ref['id']][:xref]} (draft)" }
      end

      def sequential_permission_body(id, block, label, klass, model)
        @anchors[block["id"]] = model.postprocess_anchor_struct(
          block, anchor_struct(id, nil,
                               label, klass, block["unnumbered"])
        )
        model.permission_parts(block, id, label, klass).each do |n|
          @anchors[n[:id]] = anchor_struct(n[:number], nil, n[:label],
                                           n[:klass], false)
        end
      end
    end
  end
end
