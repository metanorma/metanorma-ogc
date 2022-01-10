require "metanorma/ogc"
require "asciidoctor"
require "isodoc/ogc"

if defined? Metanorma
  Metanorma::Registry.instance.register(Metanorma::Ogc::Processor)
end
