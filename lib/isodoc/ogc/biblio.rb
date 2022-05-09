module IsoDoc
  module Ogc
    module BaseConvert
      def std_bibitem_entry(list, bib, ordinal, biblio)
        list.p **attr_code(iso_bibitem_entry_attrs(bib, biblio)) do |ref|
          prefix_bracketed_ref(ref, "[#{ordinal}]") if biblio
          reference_format(bib, ref)
        end
      end

      def nonstd_bibitem(list, bib, ordinal, bibliography)
        list.p **attr_code(iso_bibitem_entry_attrs(bib, bibliography)) do |r|
          id = bibitem_ref_code(bib)
          identifier = render_identifier(id)
          identifier[:sdo] = nil
          if bibliography
            ref_entry_code(r, ordinal, identifier, id)
          end
          reference_format(bib, r)
        end
      end
    end
  end
end
