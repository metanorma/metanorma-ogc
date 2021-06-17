require "metanorma/ogc/version"
require "metanorma/ogc/processor"

module Metanorma
  module Ogc
    def self.fonts_used
      {
        html: ["Overpass", "SpaceMono"],
        doc: ["Times New Roman", "Cambria Math", "HanSans", "Courier New"],
        pdf: ["Lato", "Arial"],
      }
    end

    ORGANIZATION_NAME_SHORT = "OGC".freeze
    ORGANIZATION_NAME_LONG = "Open Geospatial Consortium".freeze
    DOCUMENT_NAMESPACE = "https://standards.opengeospatial.org/document".freeze
  end
end
