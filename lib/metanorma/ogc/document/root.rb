# frozen_string_literal: true

require "metanorma/standoc"
module Metanorma
  module Ogc::Document
    class Root < Lutaml::Model::Serializable
      include Metanorma::Standoc::Document::RootAttributes

      attribute :bibdata, Metadata::OgcBibliographicItem
      attribute :preface,
                Metanorma::Standoc::Document::Sections::Preface
      attribute :sections,
                Metanorma::Standoc::Document::Sections::Sections
      attribute :annex,
                Metanorma::Standoc::Document::Sections::AnnexSection,
                collection: true

      xml do
        element "metanorma"
        namespace Metanorma::Standoc::Document::Namespace

        Metanorma::Standoc::Document::RootXmlMapping.apply(self)
      end
    end
  end
end
