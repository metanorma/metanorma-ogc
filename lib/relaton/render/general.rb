require "relaton-render"
require_relative "parse"
require_relative "fields"
require_relative "date"

module Relaton
  module Render
    module Ogc
      class General < ::Relaton::Render::IsoDoc::General
        def config_loc
          YAML.load_file(File.join(File.dirname(__FILE__), "config.yml"))
        end

        def klass_initialize(_options)
          super
          @fieldsklass = Relaton::Render::Ogc::Fields
          @dateklass = Relaton::Render::Ogc::Date
          @parseklass = Relaton::Render::Ogc::Parse
        end
      end
    end
  end
end
