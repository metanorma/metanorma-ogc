# frozen_string_literal: true

# Forward-declare parent namespace so this file is safe to require
# directly (without first requiring metanorma/ogc.rb).
module Metanorma
  module Ogc
  end
end


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

# OCP adoption: register the flavor with the metanorma-document harness.
# The html renderer resolves lazily (require at first render).
Metanorma.register_flavor(Metanorma::Flavor.new(
                            name: :ogc,
                            model_class: Metanorma::Ogc::Document::Root,
                            pubid_module: nil,
                            renderers: {
                              html: lambda do |_document, **_options|
                                require "metanorma/ogc/html"
                                Metanorma::Ogc::Html::Renderer
                              end,
                            },
                          ))
