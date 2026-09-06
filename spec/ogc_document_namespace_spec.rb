# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Metanorma::Ogc::Document namespace" do
  describe "canonical namespace" do
    it "exposes Metanorma::Ogc::Document as a Module" do
      expect(Metanorma::Ogc::Document).to be_a(Module)
    end

    it "exposes Root with the canonical name" do
      expect(Metanorma::Ogc::Document::Root.name)
        .to eq("Metanorma::Ogc::Document::Root")
    end

    it "Root is a lutaml Serializable" do
      expect(Metanorma::Ogc::Document::Root < Lutaml::Model::Serializable).to be(true)
    end
  end

  describe "backwards-compat alias" do
    it "Metanorma::OgcDocument aliases to the new namespace" do
      expect(Metanorma::OgcDocument).to eq(Metanorma::Ogc::Document)
    end

    it "the alias preserves class identity" do
      expect(Metanorma::OgcDocument::Root.equal?(
               Metanorma::Ogc::Document::Root)).to be(true)
    end
  end

  describe "parent namespace" do
    it "Metanorma::Standoc::Document is available" do
      expect(Metanorma::Standoc::Document).to be_a(Module)
    end

    it "Metanorma::StandardDocument alias is available" do
      expect(Metanorma::StandardDocument).to eq(Metanorma::Standoc::Document)
    end
  end
end
