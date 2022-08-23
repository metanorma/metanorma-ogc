module Metanorma
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
        insert_execsummary(xml, sect)
        insert_security(xml, sect)
        insert_submitters(xml, sect)
      end

      def add_id
        %(id="_#{UUIDTools::UUID.random_create}")
      end

      def insert_execsummary(xml, sect)
        summ = xml&.at("//clause[@type = 'executivesummary']")&.remove or
          return
        preface = sect.at("//preface") ||
          sect.add_previous_sibling("<preface/>").first
        preface.add_child summ
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
        doctype = xmldoc.at("//bibdata/ext/doctype")
        doctype.text == "technical-paper" and
          doctype.children = "white-paper"
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

      def termdef_cleanup(xmldoc)
        super
        termdef_subclause_cleanup(xmldoc)
      end

      # skip annex/terms/terms, which is empty node
      def termdef_subclause_cleanup(xmldoc)
        xmldoc.xpath("//annex//clause[terms]").each do |t|
          next unless t.xpath("./clause | ./terms | ./definitions").size == 1

          t.children.each { |n| n.parent = t.parent }
          t.remove
        end
      end

      def normref_cleanup(xmldoc)
        r1 = xmldoc.at("//references[title[translate(text(), 'R', 'r') = "\
                       "'Normative references']]")
        r2 = xmldoc.at("//references[title[text() = 'References']]")
        if r1 && r2
          r2["normative"] = false
        end
        super
      end

      def obligations_cleanup_inherit(xml)
        xml.xpath("//annex").each do |r|
          r["obligation"] = "informative" unless r["obligation"]
        end
        xml.xpath("//clause[not(ancestor::boilerplate)]").each do |r|
          r["obligation"] = "normative" unless r["obligation"]
        end
        xml.xpath(::Metanorma::Standoc::Utils::SUBCLAUSE_XPATH).each do |r|
          o = r&.at("./ancestor::*/@obligation")&.text and r["obligation"] = o
        end
      end

      def sections_order_cleanup(xml)
        super
        sort_annexes(xml)
      end

      def sort_annexes(xml)
        last = xml.at("//annex[last()]") or return
        last.next = "<sentinel/>" and last = last.next_element
        gl = xml.at("//annex[.//term]") and last.previous = gl.remove
        rev = xml.at("//annex[title[normalize-space(.) = 'Revision history']]") ||
          xml.at("//annex[title[normalize-space(.) = 'Revision History']]") and
          last.previous = rev.remove
        last.remove
      end

      def sort_biblio(bib)
        bib.sort do |a, b|
          sort_biblio_key(a) <=> sort_biblio_key(b)
        end
      end

      PUBLISHER = "./contributor[role/@type = 'publisher']/organization".freeze

      OTHERIDS = "@type = 'DOI' or @type = 'metanorma' or @type = 'ISSN' or "\
                 "@type = 'ISBN'".freeze

      def pub_class(bib)
        return 1 if bib.at("#{PUBLISHER}[abbreviation = 'OGC']")
        return 1 if bib.at("#{PUBLISHER}[name = 'Open Geospatial "\
                           "Consortium']")
        return 2 if bib.at("./docidentifier[@type][not(#{OTHERIDS})]")

        3
      end

      # sort by: doc class (OGC, other standard (not DOI &c), other
      # then standard class (docid class other than DOI &c)
      # then if OGC, doc title else if other, authors
      # then docnumber if present, numeric sort
      #      else alphanumeric metanorma id (abbreviation)
      # then doc part number if present, numeric sort
      # then doc id (not DOI &c)
      # then title
      def sort_biblio_key(bib)
        pubclass = pub_class(bib)
        ids = sort_biblio_ids_key(bib)
        title = title_key(bib)
        sortkey3 = author_title_key(pubclass, title, bib)
        num = if ids[:num].nil? then ids[:abbrid]
              else sprintf("%09d", ids[:num].to_i)
              end
        "#{pubclass} :: #{ids[:type]} :: #{sortkey3} :: #{num} :: "\
          "#{sprintf('%09d', ids[:partid])} :: #{ids[:id]} :: #{title}"
      end

      def author_title_key(pubclass, title, bib)
        case pubclass
        when 1, 2 then title
        when 3
          cite = ::Relaton::Render::General.new
            .render_all("<references>#{bib.to_xml}</references>")
          cite[:author]
        end
      end

      def title_key(bib)
        title = bib.at("./title[@type = 'main']") ||
          bib.at("./title") || bib.at("./formattedref")
        title&.text&.sub!(/^(OGC|Open Geospatial Consortium)\b/, "")
      end

      def sort_biblio_ids_key(bib)
        id = bib.at("./docidentifier[@primary]") ||
          bib.at("./docidentifier[not(#{OTHERIDS})]")
        metaid = bib.at("./docidentifier[@type = 'metanorma']")&.text
        /\d-(?<partid>\d+)/ =~ id&.text
        { id: id&.text,
          num: bib.at("./docnumber")&.text,
          abbrid: /^\[\d+\]$/.match?(metaid) ? metaid : nil,
          partid: partid&.to_i || 0,
          type: id ? id["type"] : nil }
      end
    end
  end
end
