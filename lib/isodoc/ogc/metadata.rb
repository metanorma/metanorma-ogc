require "isodoc"
require "iso-639"

module IsoDoc
  module Ogc

    class Metadata < IsoDoc::Metadata
      def initialize(lang, script, labels)
        super
        set(:status, "XXX")
      end

      def title(isoxml, _out)
        main = isoxml&.at(ns("//bibdata/title[@language='en']"))&.text
        set(:doctitle, main)
      end

      def subtitle(_isoxml, _out)
        nil
      end

      def author(isoxml, _out)
        tc = isoxml.at(ns("//bibdata/editorialgroup/committee"))
        set(:tc, tc.text) if tc
        authors = isoxml.xpath(ns("//bibdata/contributor[role/@type = 'author']/person/name"))
        set(:authors, extract_person_names(authors))
        editors = isoxml.xpath(ns("//bibdata/contributor[role/@type = 'editor']/person/name"))
        set(:editors, extract_person_names(editors))
      end

      def extract_person_names(authors)
        ret = []
        authors.each do |a|
          if a.at(ns("./completename"))
            ret << a.at(ns("./completename")).text
          else
            fn = []
            forenames = a.xpath(ns("./forename"))
            forenames.each { |f| fn << f.text }
            surname = a&.at(ns("./surname"))&.text
            ret << fn.join(" ") + " " + surname
          end
        end
        ret
      end

      def docid(isoxml, _out)
        set(:docnumber, isoxml&.at(ns("//bibdata/docidentifier[@type = 'ogc-internal']"))&.text)
        set(:externalid, isoxml&.at(ns("//bibdata/docidentifier[@type = 'ogc-external']"))&.text)
      end

      def status_print(status)
        status.split(/-/).map{ |w| w.capitalize }.join(" ")
      end

      def status_abbr(status)
      end

      def keywords(isoxml, _out)
        keywords = []
        isoxml.xpath(ns("//bibdata/keyword")).each do |kw|
          keywords << kw.text
        end
        set(:keywords, keywords)
      end

      def version(isoxml, _out)
        super
        revdate = get[:revdate]
        set(:revdate_monthyear, monthyr(revdate))
        set(:edition, isoxml&.at(ns("//version/edition"))&.text)
        set(:language, ISO_639.find_by_code(isoxml&.at(ns("//bibdata/language"))&.text))
      end

      MONTHS = {
        "01": "January",
        "02": "February",
        "03": "March",
        "04": "April",
        "05": "May",
        "06": "June",
        "07": "July",
        "08": "August",
        "09": "September",
        "10": "October",
        "11": "November",
        "12": "December",
      }.freeze

      def monthyr(isodate)
        m = /(?<yr>\d\d\d\d)-(?<mo>\d\d)/.match isodate
        return isodate unless m && m[:yr] && m[:mo]
        return "#{MONTHS[m[:mo].to_sym]} #{m[:yr]}"
      end

      def url(xml, _out)
        super
        a = xml.at(ns("//bibdata/source[@type = 'previous']")) and set(:previousuri, a.text)
      end
    end
  end
end
