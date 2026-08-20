# frozen_string_literal: true

require "bundler/setup"
require "rspec/matchers"
require "metanorma/ogc/document"
require_relative "support/roundtrip_helper"
require_relative "support/shared_roundtrip_examples"

RSpec.describe "OGC document XML round-trip" do
  it_behaves_like "xml round-trip", flavor_dir: "ogc", doc_class: Metanorma::Ogc::Document::Root
end
