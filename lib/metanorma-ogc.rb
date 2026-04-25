require "metanorma/ogc"
require "asciidoctor"
require "isodoc/ogc"
require "metanorma-core"

if defined? Metanorma::Registry
  Metanorma::Registry.instance.register(Metanorma::Ogc::Processor)
end
