module IsoDoc
  module Ogc
    class Counter < IsoDoc::XrefGen::Counter
    end

    class Xref < IsoDoc::Xref
      def initialize(lang, script, klass, labels, options)
        @reqtlabels = {}
        super
      end

      def reqtlabels
        @reqtlabels
      end

      FIRST_LVL_REQ = IsoDoc::XrefGen::Blocks::FIRST_LVL_REQ

      def sequential_permission_names(clause, klass, label)
        c = Counter.new
        clause.xpath(ns(".//#{klass}#{FIRST_LVL_REQ}")).each do |t|
          next if t["id"].nil? || t["id"].empty?

          id = c.increment(t).print
          @anchors[t["id"]] = anchor_struct(id, t, label, klass,
                                            t["unnumbered"])
          l = t.at(ns("./label"))&.text and @reqtlabels[l] = t["id"]
          permission_parts(t, label, klass)
          sequential_permission_children(t, id)
        end
      end

      def req_class_paths
        { "class" => "@type = 'class'",
          "test" => "@type = 'verification'",
          "" => "not(@type = 'verification' or @type = 'class' or "\
                "@type = 'abstracttest' or @type = 'conformanceclass')" }
      end

      def req_class_paths2
        { "abstracttest" => "@type = 'abstracttest'",
          "conformanceclass" => "@type = 'conformanceclass'" }
      end

      def permission_parts(block, label, klass)
        block.xpath(ns("./component[@class = 'part']"))
          .each_with_index do |c, i|
          next if c["id"].nil? || c["id"].empty?

          @anchors[c["id"]] = anchor_struct((i + "A".ord).chr.to_s, c, label,
                                            klass, c["unnumbered"])
        end
      end

      REQS = %w(permission requirement recommendation).freeze

      def sequential_permission_children(block, idx)
        req_class_paths.each do |k, v|
          REQS.each do |r|
            sequential_permission_names1(block, idx, "#{r}[#{v}]",
                                         @labels["#{r}#{k}"])
          end
        end
        req_class_paths2.each do |k, v|
          sequential_permission_names1(block, idx, "*[#{v}]", @labels[k])
        end
      end

      def sequential_permission_names1(block, lbl, klass, label)
        c = Counter.new
        block.xpath(ns("./#{klass}")).each do |t|
          next if t["id"].nil? || t["id"].empty?

          id = "#{lbl}#{hierfigsep}#{c.increment(t).print}"
          @anchors[t["id"]] = anchor_struct(id, t, label, klass,
                                            t["unnumbered"])
          permission_parts(t, label, klass)
          sequential_permission_children(t, id)
        end
      end

      def sequential_asset_names(clause)
        sequential_table_names(clause)
        sequential_figure_names(clause)
        sequential_formula_names(clause)
        req_class_paths.each do |k, v|
          REQS.each do |r|
            sequential_permission_names(clause, "#{r}[#{v}]",
                                        @labels["#{r}#{k}"])
          end
        end
        req_class_paths2.each do |k, v|
          sequential_permission_names(clause, "*[#{v}]", @labels[k])
        end
      end

      def hierarchical_asset_names(clause, num)
        hierarchical_table_names(clause, num)
        hierarchical_figure_names(clause, num)
        hierarchical_formula_names(clause, num)
        req_class_paths.each do |k, v|
          REQS.each do |r|
            hierarchical_permission_names(clause, num, "#{r}[#{v}]",
                                          @labels["#{r}#{k}"])
          end
        end
        req_class_paths2.each do |k, v|
          hierarchical_permission_names(clause, num, "*[#{v}]", @labels[k])
        end
      end

      def hierarchical_permission_names(clause, num, klass, label)
        c = Counter.new
        clause.xpath(ns(".//#{klass}#{FIRST_LVL_REQ}")).each do |t|
          next if t["id"].nil? || t["id"].empty?

          lbl = "#{num}#{hiersep}#{c.increment(t).print}"
          @anchors[t["id"]] = anchor_struct(lbl, t, label, klass,
                                            t["unnumbered"])
          l = t.at(ns("./label"))&.text and @reqtlabels[l] = t["id"]
          permission_parts(t, label, klass)
          sequential_permission_children(t, lbl)
        end
      end

      def initial_anchor_names(doc)
        preface_anchor_names(doc)
        n = Counter.new
        n = section_names(doc.at(ns("//clause[@type = 'scope']")), n, 1)
        n = section_names(doc.at(ns("//clause[@type = 'conformance']")), n, 1)
        n = section_names(doc.at(ns(@klass.norm_ref_xpath)), n, 1)
        n = section_names(
          doc.at(ns("//sections/terms | //sections/clause[descendant::terms]")),
          n, 1
        )
        n = section_names(doc.at(ns("//sections/definitions")), n, 1)
        middle_section_asset_names(doc)
        clause_names(doc, n)
        termnote_anchor_names(doc)
        termexample_anchor_names(doc)
      end

      def preface_anchor_names(doc)
        @prefacenum = 0
        ["//preface/abstract", "//preface/clause[@type = 'executivesummary']",
         "//preface/clause[@type = 'keywords']",
         "//foreword", "//introduction", "//preface/clause[@type = 'security']",
         "//preface/clause[@type = 'submitting_orgs']",
         "//submitters"].each do |path|
          preface_names_numbered(doc.at(ns(path)))
        end
        doc.xpath(ns("//preface/clause[not(@type = 'keywords' or "\
                     "@type = 'submitting_orgs' or @type = 'security' or "\
                     "@type = 'executivesummary')]"))
          .each { |c| preface_names_numbered(c) }
        preface_names_numbered(doc.at(ns("//acknowledgements")))
        sequential_asset_names(
          doc.xpath(ns("//preface/abstract | //foreword | //introduction | "\
                       "//submitters | //acknowledgements | //preface/clause")),
        )
      end

      def middle_section_asset_names(doc)
        middle_sections =
          "//clause[@type = 'scope' or @type = 'conformance'] | //foreword | "\
          "//introduction | //preface/abstract | //submitters | "\
          "//acknowledgements | //preface/clause | "\
          " #{@klass.norm_ref_xpath} | //sections/terms | "\
          "//sections/definitions | //clause[parent::sections]"
        sequential_asset_names(doc.xpath(ns(middle_sections)))
      end

      def preface_names_numbered(clause)
        return if clause.nil?

        @prefacenum += 1
        pref = preface_number(@prefacenum, 1)
        @anchors[clause["id"]] =
          { label: pref,
            level: 1, xref: preface_clause_name(clause), type: "clause" }
        clause.xpath(ns(SUBCLAUSES)).each_with_index do |c, i|
          preface_names_numbered1(c, "#{pref}.#{preface_number(i + 1, 2)}", 2)
        end
      end

      def preface_names_numbered1(clause, num, level)
        @anchors[clause["id"]] =
          { label: num, level: level, xref: l10n("#{@labels['clause']} #{num}"),
            type: "clause" }
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

        @anchors[ref["id"]] = { xref: "#{@anchors[ref['id']][:xref]}  (draft)" }
      end
    end
  end
end
