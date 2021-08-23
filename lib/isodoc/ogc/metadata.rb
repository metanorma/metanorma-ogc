require "isodoc"
require "iso-639"

module IsoDoc
  module Ogc
    DOCTYPE_ABBR = {
      "standard" => "IS",
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
      def initialize(lang, script, i18n)
        super
        here = File.dirname(__FILE__)
        set(:logo_word,
            File.expand_path(File.join(here, "html", "logo.png")))
      end

      def title(isoxml, _out)
        main = isoxml&.at(ns("//bibdata/title[@language='en']"))&.text
        set(:doctitle, main)
      end

      def subtitle(_isoxml, _out)
        nil
      end

      def author(isoxml, _out)
        tc = isoxml.at(ns("//bibdata/ext/editorialgroup/committee"))
        set(:tc, tc.text) if tc
        authors = isoxml.xpath(ns("//bibdata/contributor"\
                                  "[role/@type = 'author']/person"))
        set(:authors, extract_person_names(authors))
        editors = isoxml.xpath(ns("//bibdata/contributor"\
                                  "[role/@type = 'editor']/person"))
        set(:editors, extract_person_names(editors))
        agency(isoxml)
      end

      def docid(isoxml, _out)
        set(:docnumber, isoxml&.at(ns("//bibdata/docidentifier"\
                                      "[@type = 'ogc-internal']"))&.text)
        set(:externalid, isoxml&.at(ns("//bibdata/docidentifier"\
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
        IsoDoc::Ogc::DOCSUBTYPE_ABBR[subtype] || st
      end

      def status_print(status)
        type_capitalise(status)
      end
    end
  end
end
