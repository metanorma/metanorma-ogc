require "metanorma/ogc/version"
require "metanorma/ogc/processor"
require "metanorma/ogc/converter"

module Metanorma
  module Ogc
    def self.fonts_used
      {
        html: ["Overpass", "SpaceMono"],
        doc: ["EB Garamond", "STIX Two Math", "HanSans", "Courier Prime"],
        pdf: ["Lato", "Roboto"],
      }
    end

    ORGANIZATION_NAME_SHORT = "OGC".freeze
    ORGANIZATION_NAME_LONG = "Open Geospatial Consortium".freeze
    DOCUMENT_NAMESPACE = "https://standards.opengeospatial.org/document".freeze
  end
end
