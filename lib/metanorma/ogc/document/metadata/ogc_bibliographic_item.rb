# frozen_string_literal: true

module Metanorma
  module Ogc::Document
    module Metadata
      # The bibliographical description of an OGC document.
      # Adds keyword element; OGC uses the same ext as ISO.
      class OgcBibliographicItem < Metanorma::IsoDocument::Metadata::IsoBibliographicItem
        attribute :keyword, :string, collection: true
        attribute :ext, OgcBibDataExtensionType

        xml do
          element "bibdata"
          map_element "keyword", to: :keyword
        end
      end
    end
  end
end
