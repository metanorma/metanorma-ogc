require "metanorma/ogc/version"
require "metanorma/ogc/document"
require "metanorma/ogc/processor"
require "metanorma/ogc/converter"
require "metanorma/ogc/cleanup"
require "metanorma/ogc/validate"

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

# Registry styling: the flavor owns its index theme, registered
# programmatically with the metanorma-document theme system.
begin
  require "metanorma/html"
  Metanorma::Html::Theme.register_themes_dir(
    File.expand_path("ogc/themes", __dir__),
  )
rescue LoadError
  # metanorma-document unavailable; registry styling inert
end
