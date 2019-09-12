module IsoDoc
  module Ogc
    module BaseConvert
      def std_bibitem_entry(list, b, ordinal, biblio)
        list.p **attr_code(iso_bibitem_entry_attrs(b, biblio)) do |ref|
          prefix_bracketed_ref(ref, ordinal) if biblio
          standard_citation(ref, b)
        end
      end

      def nonstd_bibitem(list, b, ordinal, bibliography)
        list.p **attr_code(iso_bibitem_entry_attrs(b, bibliography)) do |r|
          id = bibitem_ref_code(b)
          identifier = render_identifier(id)
          if bibliography
            ref_entry_code(r, ordinal, identifier, id)
          end
          reference_format(b, r)
        end
      end

      def reference_format(b, r)
        if ftitle = b.at(ns("./formattedref"))
          ftitle&.children&.each { |n| parse(n, r) }
        else
          # eventually will be full LNCS reference
          standard_citation(r, b)
        end
      end

      def multiplenames(names)
        names.join(", ")
      end

      def multiplenames_and(names)
        return "" if names.length == 0
        return names[0] if names.length == 1
        return "#{names[0]} and #{names[1]}" if names.length == 2
        names[0..-2].join(", ") + " and #{names[-1]}"
      end

      def nodes_to_span(n)
        noko do |xml|
          xml.span do |s|
            n&.children&.each { |x| parse(x, s) }
          end
        end.join("")
      end

      def extract_publisher(b)
        c = b.xpath(ns("./contributor[role/@type = 'publisher'][organization]"))
        abbrs = []
        names = []
        c&.each do |c1|
          n = c1.at(ns("./organization/name")) or next
          abbrs << (c1.at(ns("./organization/abbreviation")) || n)
          names << nodes_to_span(n)
        end
        return [nil, nil] if names.empty?
        return [multiplenames_and(names), (abbrs.map { |x| x.text }).join("/")]
      end

      def date_render(date)
        return nil if date.nil?
        on = date&.at(ns("./on"))&.text
        from = date&.at(ns("./from"))&.text
        to = date&.at(ns("./to"))&.text
        return on if on
        return "#{from}&ndash;#{to}" if from
        nil
      end

      def extract_year(b)
        d = b.at(ns("./date[@type = 'published']")) ||
          b.at(ns("./date[@type = 'issued']")) ||
          b.at(ns("./date[@type = 'circulated']")) ||
          b.at(ns("./date"))
        date_render(d)
      end

      def extract_city(b)
        b.at(ns("./place"))
      end

      # {author}: {document identifier}, {title}. {publisher}, {city} ({year})
      def standard_citation(out, b)
        if ftitle = b.at(ns("./formattedref"))
          ftitle&.children&.each { |n| parse(n, out) }
        else
          pub, pub_abbrev = extract_publisher(b)
          c = extract_city(b)
          y = extract_year(b)
          out << "#{pub_abbrev}: " if pub_abbrev
          out << render_identifier(bibitem_ref_code(b))
          out << ", "
          out.i do |i|
            iso_title(b)&.children&.each { |n| parse(n, i) }
          end
          out << ". "
          out << pub if pub
          out << ", " if pub && c
          c&.children&.each { |n| parse(n, out) }
          out << " " if (pub || c) && y
          out << "(#{y})." if y
        end
      end
    end
  end
end
