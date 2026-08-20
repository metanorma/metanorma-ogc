# frozen_string_literal: true

module Metanorma
  module Ogc::Document
    module Metadata
      autoload :OgcBibDataExtensionType,
               "#{__dir__}/metadata/ogc_bib_data_extension_type"
      autoload :OgcBibliographicItem,
               "#{__dir__}/metadata/ogc_bibliographic_item"
    end
  end
end
