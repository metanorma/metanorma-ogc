module IsoDoc
  module Ogc
    module BaseConvert
      FIRST_LVL_REQ = IsoDoc::Function::XrefGen::FIRST_LVL_REQ

      def sequential_permission_names(clause, klass, label)
        c = ::IsoDoc::Function::XrefGen::Counter.new
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
        c = ::IsoDoc::Function::XrefGen::Counter.new
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
        c = ::IsoDoc::Function::XrefGen::Counter.new
        clause.xpath(ns(".//#{klass}#{FIRST_LVL_REQ}")).each do |t|
          next if t["id"].nil? || t["id"].empty?
          lbl = "#{num}#{hiersep}#{c.increment(t).print}"
          @anchors[t["id"]] = anchor_struct(lbl, t, label, klass, t["unnumbered"])
          l = t.at(ns("./label"))&.text and @reqtlabels[l] = t["id"]
          sequential_permission_children(t, lbl)
        end
      end
    end
  end
end
