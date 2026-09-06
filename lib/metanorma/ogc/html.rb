# frozen_string_literal: true

require "metanorma/document"

module Metanorma
  module Ogc
    # HTML format slice for the OGC flavor.
    module Html
      autoload :Renderer, "#{__dir__}/html/renderer"
    end
  end
end
