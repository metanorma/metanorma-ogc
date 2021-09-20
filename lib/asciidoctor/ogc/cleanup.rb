module Asciidoctor
  module Ogc
    class Converter < Standoc::Converter
      def sections_cleanup(xml)
        super
        xml.xpath("//*[@inline-header]").each do |h|
          h.delete("inline-header")
        end
      end

      def make_preface(xml, sect)
        super
        insert_security(xml, sect)
        insert_submitters(xml, sect)
      end

      def add_id
        %(id="_#{UUIDTools::UUID.random_create}")
      end

      def insert_security(xml, sect)
        description = "document"
        description = "standard" if %w(standard community-standard)
          .include?(sect&.at("//bibdata/ext/doctype")&.text)
        preface = sect.at("//preface") ||
          sect.add_previous_sibling("<preface/>").first
        sect = xml&.at("//clause[@type = 'security']")&.remove ||
          "<clause type='security' #{add_id}>"\
          "<title>Security considerations</title>"\
          "<p>#{@i18n.security_empty.sub(/%/, description)}</p></clause>"
        preface.add_child sect
      end

      def insert_submitters(xml, sect)
        if xml.at("//submitters")
          preface = sect.at("//preface") ||
            sect.add_previous_sibling("<preface/>").first
          submitters = xml.at("//submitters").remove
          submitters.xpath(".//table").each do |t|
            t["unnumbered"] = true
          end
          preface.add_child submitters.remove
        end
      end

      def termdef_boilerplate_cleanup(xmldoc); end

      def bibdata_cleanup(xmldoc)
        super
        a = xmldoc.at("//bibdata/status/stage")
        a.text == "published" and a.children = "approved"
      end

      def section_names_terms_cleanup(xml)
        replace_title(xml, "//definitions[@type = 'symbols']", @i18n&.symbols)
        replace_title(xml, "//definitions[@type = 'abbreviated_terms']",
                      @i18n&.abbrev)
        replace_title(xml, "//definitions[not(@type)]", @i18n&.symbolsabbrev)
        replace_title(xml, "//sections//terms#{SYMnoABBR} | "\
                           "//sections//clause[.//terms]#{SYMnoABBR}",
                      @i18n&.termsdefsymbols, true)
        replace_title(xml, "//sections//terms#{ABBRnoSYM} | "\
                           "//sections//clause[.//terms]#{ABBRnoSYM}",
                      @i18n&.termsdefabbrev, true)
        replace_title(xml, "//sections//terms#{SYMABBR} | "\
                           "//sections//clause[.//terms]#{SYMABBR}",
                      @i18n&.termsdefsymbolsabbrev, true)
        replace_title(xml, "//sections//terms#{NO_SYMABBR} | "\
                           "//sections//clause[.//terms]#{NO_SYMABBR}",
                      @i18n&.termsdefsymbolsabbrev, true)
        replace_title(xml, "//sections//terms[not(.//definitions)] | "\
                           "//sections//clause[.//terms][not(.//definitions)]",
                      @i18n&.termsdef, true)
      end

      def requirement_metadata_component_tags
        %w(test-purpose test-method test-method-type conditions part description
           reference step requirement permission recommendation)
      end

      def requirement_metadata1(reqt, dlist)
        ins = super
        dlist.xpath("./dt").each do |e|
          tag = e&.text&.gsub(/ /, "-")&.downcase
          next unless requirement_metadata_component_tags.include? tag

          ins.next = requirement_metadata1_component(e, tag)
          ins = ins.next
        end
      end

      def requirement_metadata1_component(term, tag)
        val = term.at("./following::dd")
        val.name = tag
        val.xpath("./dl").each { |d| requirement_metadata1(val, d.remove) }
        if %w(requirement permission
              recommendation).include?(term.text) && !val.text.empty?
          val["label"] = val.text.strip
          val.children.remove
        end
        val
      end

      def requirement_metadata(xmldoc)
        super
        xmldoc.xpath(REQRECPER).each do |r|
          requirement_metadata_to_component(r)
          requirement_metadata_to_requirement(r)
          requirement_subparts_to_blocks(r)
        end
      end

      def requirement_metadata_to_component(reqt)
        reqt.xpath(".//test-method | .//test-purpose | .//conditions | "\
                   ".//part | .//test-method-type | .//step | .//reference")
          .each do |c|
          c["class"] = c.name
          c.name = "component"
        end
      end

      def requirement_metadata_to_requirement(reqt)
        reqt.xpath("./requirement | ./permission | ./recommendation")
          .each do |c|
          c["id"] = Metanorma::Utils::anchor_or_uuid
        end
      end

      def requirement_subparts_to_blocks(reqt)
        reqt.xpath(".//component | .//description").each do |c|
          next if %w(p ol ul dl table component description)
            .include?(c&.elements&.first&.name)

          c.children = "<p>#{c.children.to_xml}</p>"
        end
      end

      # skip annex/terms/terms, which is empty node
      def termdef_subclause_cleanup(xmldoc)
        xmldoc.xpath("//annex//terms[terms]").each do |t|
          next if t.parent.name == "terms"

          t.children.each { |n| n.parent = t.parent }
          t.remove
        end
      end

      def requirement_cleanup(xmldoc)
        requirement_type(xmldoc)
        super
      end

      def requirement_type(xmldoc)
        xmldoc.xpath(REQRECPER).each do |r|
          next unless r["type"]

          r["type"] = case r["type"]
                      when "requirement", "recommendation", "permission"
                        "general"
                      when "requirement_class" then "class"
                      when "conformance_test" then "verification"
                      when "conformance_class" then "conformanceclass"
                      when "abstract_test" then "abstracttest"
                      else r["type"]
                      end
        end
      end
    end
  end
end
