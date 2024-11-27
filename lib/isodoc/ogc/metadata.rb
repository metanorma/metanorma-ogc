require "isodoc"
require "iso-639"

module IsoDoc
  module Ogc
    DOCTYPE_ABBR = {
      "standard" => "IS",
      "draft-standard" => "DS",
      "abstract-specification-topic" => "AST",
      "best-practice" => "BP",
      "change-request-supporting-document" => "CRSD",
      "community-practice" => "CP",
      "community-standard" => "CS",
      "discussion-paper" => "DP",
      "engineering-report" => "ER",
      "policy" => "POL",
      "reference-model" => "RM",
      "release-notes" => "RN",
      "test-suite" => "TS",
      "user-guide" => "UG",
      "white-paper" => "WP",
      "technical-paper" => "TP",
      "other" => "other",
    }.freeze

    DOCSUBTYPE_ABBR = {
      "implementation" => "IMP",
      "conceptual-model" => "CM",
      "conceptual-model-and-encoding" => "CME",
      "conceptual-model-and-implementation" => "CMI",
      "encoding" => "EN",
      "extension" => "EXT",
      "profile" => "PF",
      "profile-with-extension" => "PFE",
      "general" => "GE",
    }.freeze

    class Metadata < IsoDoc::Metadata
      def initialize(lang, script, locale, i18n)
        super
        here = File.dirname(__FILE__)
        set(:logo_old,
            File.expand_path(File.join(here, "html", "logo.png")))
        set(:logo_new,
            File.expand_path(File.join(here, "html",
                                       "logo.2021.svg")))
      end

      def title(isoxml, _out)
        main = isoxml.at(ns("//bibdata/title[@language='en']"))
          &.children&.to_xml
        set(:doctitle, main)
        main = isoxml.at(ns("//bibdata/abstract"))
          &.text&.strip&.gsub(/\s+/, " ")
        set(:abstract, main)
      end

      def subtitle(_isoxml, _out)
        nil
      end

      def author(isoxml, _out)
        tc = isoxml.at(ns("//bibdata/ext/editorialgroup/committee"))
        set(:tc, tc.text) if tc
        authors = isoxml.xpath(ns("//bibdata/contributor" \
                                  "[role/@type = 'author']/person"))
        set(:authors, extract_person_names(authors))
        editors = isoxml.xpath(ns("//bibdata/contributor" \
                                  "[role/@type = 'editor']/person"))
        set(:editors, extract_person_names(editors))
        contributors = isoxml.xpath(ns("//bibdata/contributor" \
                                       "[role/@type = 'contributor']/person"))
        set(:contributors, extract_person_names(contributors))
        agency(isoxml)
        copyright(isoxml)
      end

      def copyright(isoxml)
        c = isoxml.xpath(ns("//bibdata/copyright/owner/organization/name"))
          .each_with_object([]) do |n, m|
          m << n.text
        end
        c.empty? and c = ["Open Geospatial Consortium"]
        set(:copyright_holder, connectives_strip(@i18n.boolean_conj(c, "and")))
      end

      def docid(isoxml, _out)
        set(:docnumber, isoxml&.at(ns("//bibdata/docidentifier" \
                                      "[@type = 'ogc-internal']"))&.text)
        set(:externalid, isoxml&.at(ns("//bibdata/docidentifier" \
                                       "[@type = 'ogc-external']"))&.text)
      end

      def unpublished(status)
        !%w(approved deprecated retired).include?(status.downcase)
      end

      def version(isoxml, _out)
        super
        set(:edition, isoxml&.at(ns("//bibdata/edition"))&.text)
        lg = ISO_639.find_by_code(isoxml&.at(ns("//bibdata/language"))&.text)
        set(:doclanguage, lg ? lg[3] : "English")
      end

      def url(xml, _out)
        super
        a = xml.at(ns("//bibdata/uri[@type = 'previous']")) and
          set(:previousuri, a.text)
      end

      def type_capitalise(type)
        type.split(/[- ]/).map do |w|
          %w(SWG).include?(w) ? w : w.capitalize
        end.join(" ")
      end

      def doctype(isoxml, _out)
        if t = isoxml&.at(ns("//bibdata/ext/doctype"))&.text
          set(:doctype, type_capitalise(t))
          set(:doctype_abbr, doctype_abbr(t))
          if st = isoxml&.at(ns("//bibdata/ext/subdoctype"))&.text
            set(:docsubtype, type_capitalise(st))
            set(:docsubtype_abbr, docsubtype_abbr(st, t))
          end
        end
      end

      def doctype_abbr(type)
        IsoDoc::Ogc::DOCTYPE_ABBR[type] || type
      end

      def docsubtype_abbr(subtype, _type)
        IsoDoc::Ogc::DOCSUBTYPE_ABBR[subtype] || subtype
      end

      def status_print(status)
        type_capitalise(status)
      end

      def docdate(isoxml)
        isoxml.xpath(ns("//bibdata/date[@type = 'published']/on")) ||
          isoxml.xpath(ns("//bibdata/date[@type = 'published']/from")) ||
          isoxml.xpath(ns("//bibdata/date[@type = 'issued']/on")) ||
          isoxml.xpath(ns("//bibdata/date[@type = 'issued']/from")) ||
          isoxml.xpath(ns("//bibdata/date/from")) ||
          isoxml.xpath(ns("//bibdata/date/on"))
      end

      def bibdate(isoxml, _out)
        super
        d = docdate(isoxml)
        begin
          old = d.nil? || d.empty? ||
            DateTime.iso8601("2021-11-08") > DateTime.parse(d.text)
        rescue StandardError
          old = false
        end
        set(:logo_word, old ? get[:logo_old] : get[:logo_new])
      end

      def presentation(xml, _out)
        super
        @metadata.each do |k, v|
          /^presentation_metadata_color_/.match?(k) or next
          v.is_a?(Array) or next
          m = /^rgb\((\d+),\s*(\d+),\s*(\d+)\s*\)/.match(Array(v).first)
          @metadata[k] =
            sprintf("#%02x%02x%02x", m[1].to_i, m[2].to_i, m[3].to_i)
        end
      end
    end
  end
end
