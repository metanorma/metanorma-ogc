require_relative "init"
require "isodoc"

module IsoDoc
  module Ogc
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      include Init
    end
  end
end

