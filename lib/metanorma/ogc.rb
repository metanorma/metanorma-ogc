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

    ORGANIZATION_NAME_SHORT = "OGC"
    ORGANIZATION_NAME_LONG = "Open Geospatial Consortium"
    DOCUMENT_NAMESPACE = "https://standards.opengeospatial.org/document"

  end
end
