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
        %w(test-purpose test-method conditions part description reference
           requirement permission recommendation)
      end

      def requirement_metadata1(reqt, dlist)
        ins = super
        dlist.xpath("./dt").each do |e|
          next unless requirement_metadata_component_tags.include? e.text

          ins.next = requirement_metadata1_component(e)
          ins = ins.next
        end
      end

      def requirement_metadata1_component(term)
        val = term.at("./following::dd")
        val.name = term.text
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
        reqt.xpath("./test-method | ./test-purpose | ./conditions | ./part | "\
                   "./reference")
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
        reqt.xpath("./component | ./description").each do |c|
          %w(p ol ul dl table).include?(c&.elements&.first&.name) and next
          c.children = "<p>#{c.children.to_xml}</p>"
        end
      end
    end
  end
end
