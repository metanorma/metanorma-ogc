# frozen_string_literal: true

require "metanorma/iso/html"

module Metanorma
  module Ogc
    module Html
      # OGC documents render iso-style with OGC-specific section
      # dispatch. Registered with the harness from ogc/document.rb.
      register_render "Metanorma::Standoc::Document::Sections::Preface",
                      :render_preface
      register_render "Metanorma::Standoc::Document::Sections::ClauseSection",
                      :render_clause
      register_render "Metanorma::Standoc::Document::Sections::AnnexSection",
                      :render_annex
      register_render "Metanorma::Standoc::Document::Sections::ContentSection",
                      :render_clause
      register_render "Metanorma::Standoc::Document::Sections::TermsSection",
                      :render_terms_section
      register_render "Metanorma::Standoc::Document::Sections::BibliographySection",
                      :render_clause
      register_render "Metanorma::Standoc::Document::Sections::DefinitionSection",
                      :render_clause
    end
  end
end
