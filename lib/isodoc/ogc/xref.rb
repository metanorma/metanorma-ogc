module IsoDoc
  module Ogc
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
        c = ::IsoDoc::XrefGen::Counter.new
        clause.xpath(ns(".//#{klass}#{FIRST_LVL_REQ}")).each do |t|
          next if t["id"].nil? || t["id"].empty?
          id = c.increment(t).print
          @anchors[t["id"]] = anchor_struct(id, t, label, klass, t["unnumbered"])
          l = t.at(ns("./label"))&.text and @reqtlabels[l] = t["id"]
          sequential_permission_children(t, id)
        end
      end

      def req_class_paths
        { "class" => "@type = 'class'", 
          "test" => "@type = 'verification'", 
          "" => "not(@type = 'verification' or @type = 'class' or "\
          "@type = 'abstracttest' or @type = 'conformanceclass')", }
      end

      def req_class_paths2
        { "abstracttest" => "@type = 'abstracttest'",
          "conformanceclass" => "@type = 'conformanceclass'", }
      end

      def sequential_permission_children(t, id)
        req_class_paths.each do |k, v|
          %w(permission requirement recommendation).each do |r|
            sequential_permission_names1(t, id, "#{r}[#{v}]", @labels["#{r}#{k}"])
            sequential_permission_names1(t, id, "#{r}[#{v}]", @labels["#{r}#{k}"])
            sequential_permission_names1(t, id, "#{r}[#{v}]", @labels["#{r}#{k}"])
          end
        end
        req_class_paths2.each do |k, v|
          sequential_permission_names1(t, id, "*[#{v}]", @labels[k])
        end
      end

      def sequential_permission_names1(block, lbl, klass, label)
        c = ::IsoDoc::XrefGen::Counter.new
        block.xpath(ns("./#{klass}")).each do |t|
          next if t["id"].nil? || t["id"].empty?
          id = "#{lbl}#{hierfigsep}#{c.increment(t).print}"
          @anchors[t["id"]] = anchor_struct(id, t, label, klass, t["unnumbered"])
          sequential_permission_children(t, id)
        end
      end

      def sequential_asset_names(clause)
        sequential_table_names(clause)
        sequential_figure_names(clause)
        sequential_formula_names(clause)
        req_class_paths.each do |k, v|
          %w(permission requirement recommendation).each do |r|
            sequential_permission_names(clause, "#{r}[#{v}]", @labels["#{r}#{k}"])
            sequential_permission_names(clause, "#{r}[#{v}]", @labels["#{r}#{k}"])
            sequential_permission_names(clause, "#{r}[#{v}]", @labels["#{r}#{k}"])
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
          %w(permission requirement recommendation).each do |r|
            hierarchical_permission_names(clause, num, "#{r}[#{v}]", @labels["#{r}#{k}"])
            hierarchical_permission_names(clause, num, "#{r}[#{v}]", @labels["#{r}#{k}"])
            hierarchical_permission_names(clause, num, "#{r}[#{v}]",  @labels["#{r}#{k}"])
          end
        end
        req_class_paths2.each do |k, v|
          hierarchical_permission_names(clause, num, "*[#{v}]", @labels[k])
        end
      end

      def hierarchical_permission_names(clause, num, klass, label)
        c = ::IsoDoc::XrefGen::Counter.new
        clause.xpath(ns(".//#{klass}#{FIRST_LVL_REQ}")).each do |t|
          next if t["id"].nil? || t["id"].empty?
          lbl = "#{num}#{hiersep}#{c.increment(t).print}"
          @anchors[t["id"]] = anchor_struct(lbl, t, label, klass, t["unnumbered"])
          l = t.at(ns("./label"))&.text and @reqtlabels[l] = t["id"]
          sequential_permission_children(t, lbl)
        end
      end

      def initial_anchor_names(d)
        @prefacenum = 0
        preface_names_numbered(d.at(ns("//preface/abstract")))
        @prefacenum += 1 if d.at(ns("//keyword"))
        preface_names_numbered(d.at(ns("//foreword")))
        preface_names_numbered(d.at(ns("//introduction")))
        @prefacenum += 1 if d.at(ns(@klass.submittingorgs_path))
        preface_names_numbered(d.at(ns("//submitters")))
        d.xpath(ns("//preface/clause")).each do |c|
          preface_names_numbered(c)
        end
        preface_names_numbered(d.at(ns("//acknowledgements")))
        sequential_asset_names(d.xpath(ns(
          "//preface/abstract | //foreword | //introduction | "\
          "//submitters | //acknowledgements | //preface/clause")))
        n = section_names(d.at(ns("//clause[@type = 'scope']")), 0, 1)
        n = section_names(d.at(ns("//clause[@type = 'conformance']")), n, 1)
        n = section_names(d.at(ns(
          "//references[title = 'Normative References' or "\
          "title = 'Normative references']")), n, 1)
        n = section_names(
          d.at(ns("//sections/terms | //sections/clause[descendant::terms]")),
          n, 1)
        n = section_names(d.at(ns("//sections/definitions")), n, 1)
        middle_section_asset_names(d)
        clause_names(d, n)
        termnote_anchor_names(d)
        termexample_anchor_names(d)
      end

      def middle_section_asset_names(d)
        middle_sections = "//clause[@type = 'scope' or @type = 'conformance'] "\
          "| //foreword | //introduction | //preface/abstract | "\
          "//submitters | //acknowledgements | //preface/clause | "\
          "//references[title = 'Normative References' or title = "\
          "'Normative references'] | //sections/terms | "\
          "//sections/definitions | //clause[parent::sections]"
        sequential_asset_names(d.xpath(ns(middle_sections)))
      end

      def preface_names_numbered(clause)
        return if clause.nil?
        @prefacenum += 1
        pref = RomanNumerals.to_roman(@prefacenum).downcase
        @anchors[clause["id"]] =
          { label: pref,
            level: 1, xref: preface_clause_name(clause), type: "clause" }
        clause.xpath(ns("./clause | ./terms | ./term | ./definitions | "\
                        "./references")).each_with_index do |c, i|
          section_names1(c, "#{pref}.#{i + 1}", 2)
        end
      end
    end
  end
end
