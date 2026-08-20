# frozen_string_literal: true

# Forward-declare parent namespace so this file is safe to require
# directly (without first requiring metanorma/ogc.rb).
module Metanorma
  module Ogc
  end
end


require "metanorma/standoc"
require "metanorma/iso/document/models"

module Metanorma
  module Ogc::Document
    autoload :Metadata, "metanorma/ogc/document/metadata"
    autoload :Root, "metanorma/ogc/document/root"
  end
end

# Backwards-compat alias so external consumers that reference
# Metanorma::OgcDocument keep resolving during the transition.
module Metanorma
  existing = defined?(Metanorma::OgcDocument) && Metanorma::OgcDocument
  if !existing.equal?(Metanorma::Ogc::Document)
    Metanorma.send(:remove_const, :OgcDocument) if existing
    OgcDocument = Metanorma::Ogc::Document
  end
end

if defined?(Metanorma::Registers::Setup.setup_ogc_register)
  Metanorma::Registers::Setup.setup_ogc_register
end

module Metanorma
  deprecate_constant :OgcDocument
end

require "metanorma-core"

# OCP adoption: ONE registration in the metanorma-core flavor table
# (metanorma-core#18). Renderer resolves lazily; iso-style today.
Metanorma::Core::Flavors.register(Metanorma::Core::Flavor.new(
  name: :ogc,
  gem: "metanorma-ogc",
  model_root: Metanorma::Ogc::Document::Root,
  pubid_module: nil,
  renderers: { html: lambda do |_document, **_options|
    require "metanorma/ogc/html"
    Metanorma::Ogc::Html::Renderer
  end },
))
