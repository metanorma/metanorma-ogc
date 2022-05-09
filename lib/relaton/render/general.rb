require "relaton-render"
require_relative "parse"
require_relative "fields"

module Relaton
  module Render
    module Ogc
      class General < ::Relaton::Render::IsoDoc::General
        def config_loc
          YAML.load_file(File.join(File.dirname(__FILE__), "config.yml"))
        end

        def klass_initialize(_options)
          @nametemplateklass = Relaton::Render::Template::Name
          @seriestemplateklass = Relaton::Render::Template::Series
          @extenttemplateklass = Relaton::Render::Template::Extent
          @sizetemplateklass = Relaton::Render::Template::Size
          @generaltemplateklass = Relaton::Render::Template::General
          @fieldsklass = Relaton::Render::Ogc::Fields
          @parseklass = Relaton::Render::Ogc::Parse
        end
      end
    end
  end
end
