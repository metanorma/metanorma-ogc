# frozen_string_literal: true

require "metanorma/iso/html"

module Metanorma
  module Ogc
    module Html
      # OGC documents render iso-style with OGC-specific section
      # dispatch. Registered with the harness from ogc/document.rb.
      class Renderer < Metanorma::Iso::Html::Renderer
        register_render "Metanorma::Ogc::Document::Root", :render_document
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

        # OGC cover identity bands (isodoc ogc coverpage-metadata and
        # docstage-box): submission/approval/publication dates, external
        # and internal identifiers, version, the document-number grid and
        # the editors roster.
        def render_coverpage(doc)
          super + ogc_cover_metadata(doc.bibdata)
        end

        private

        OGC_DATE_BANDS = {
          "received" => "Submission Date",
          "issued" => "Approval Date",
          "published" => "Publication Date",
        }.freeze

        OGC_LANGUAGES = {
          "en" => "English",
          "fr" => "French",
          "de" => "German",
          "es" => "Spanish",
          "ru" => "Russian",
          "zh" => "Chinese",
          "ja" => "Japanese",
          "ko" => "Korean",
        }.freeze

        def ogc_cover_metadata(bibdata)
          return "" unless bibdata

          parts = []
          bands = ogc_cover_bands(bibdata)
          unless bands.empty?
            parts << cover_element("div", %( class="coverpage-metadata"),
                                   cover_label_value_spans(bands))
          end

          edition = Array(safe_attr(bibdata, :edition)).first
          version = edition ? Array(edition.content).map(&:to_s).join.strip : ""
          unless version.empty?
            version_spans = cover_label_value_spans([["Version", version]])
            parts << cover_element("div", %( class="coverpage-alt-formats"),
                                   version_spans)
          end

          rows = ogc_docstage_rows(bibdata)
          unless rows.empty?
            trs = rows.map do |label, value|
              cells = [label, value].map do |cell|
                cover_element("td", "", "#{escape_html(cell)}")
              end.join
              cover_element("tr", "", cells)
            end.join
            parts << cover_element("div", %( class="docstage-box"),
                                   cover_element("table", "", trs))
          end

          editors = ogc_cover_editors(bibdata)
          unless editors.empty?
            spans = editors.map do |name|
              roletag = cover_element("span", %( class="roletag"), "Editor")
              cover_element("span", "", "#{escape_html(name)} #{roletag}")
            end.join
            parts << cover_element("div", %( class="authors"), spans)
          end

          parts.join
        end

        def cover_label_value_spans(bands)
          # Bands may carry an empty value (placeholder identifiers in
          # sample documents): the label still renders, isodoc-style.
          bands.map do |label, value|
            label_span = cover_element("span", %( class="label"),
                                       "#{escape_html(label)}: ")
            value_span = cover_element("span", %( class="value"),
                                       escape_html(value.to_s.strip))
            "#{label_span} #{value_span}"
          end.join
        end

        # isodoc's OGC cover always states the three date bands and both
        # identifier bands, printing its "XXX" placeholder for a missing
        # date value.
        MISSING_VALUE = "XXX"

        def ogc_cover_bands(bibdata)
          dates = Array(safe_attr(bibdata, :date))
          bands = OGC_DATE_BANDS.map do |type, label|
            value = dates.filter_map do |date|
              safe_attr(date, :type) == type ? extract_text_value(date.on).to_s : nil
            end.first
            [label, value.to_s.strip.empty? ? MISSING_VALUE : value]
          end

          %w[ogc-external ogc-internal].each do |type|
            value = Array(safe_attr(bibdata, :doc_identifier))
                    .filter_map { |di| safe_attr(di, :type) == type ? safe_attr(di, :value).to_s : nil }
                    .join(" ")
            bands << ["#{type == 'ogc-external' ? 'External' : 'Internal'} " \
                      "identifier of this OGC® document", value]
          end
          bands
        end

        # isodoc's docstage-box always prints all five rows.
        def ogc_docstage_rows(bibdata)
          docnumber = safe_attr(bibdata, :docnumber).to_s

          doctype = extract_doctype(bibdata).to_s
          type_display = doctype.strip.empty? ? "" : "OGC #{doctype.strip.split(/[\s-]+/).map(&:capitalize).join(' ')}"

          subdoctype = safe_attr(safe_attr(bibdata, :ext), :subdoctype).to_s

          stage = extract_stage(bibdata).to_s

          language_element = Array(safe_attr(bibdata, :language)).first
          language = extract_text_value(language_element).to_s

          [
            ["Document number", docnumber],
            ["Document type", type_display],
            ["Document subtype", subdoctype.strip.empty? ? "" : subdoctype.strip.capitalize],
            ["Document stage", stage],
            ["Document language", OGC_LANGUAGES.fetch(language.downcase, language)],
          ]
        end

        def ogc_cover_editors(bibdata)
          Array(safe_attr(bibdata, :contributor)).filter_map do |contributor|
            next unless Array(contributor.role).any? { |r| safe_attr(r, :type) == "editor" }
            next unless contributor.person

            Array(contributor.person.name&.completename).map do |name|
              extract_text_value(name).to_s
            end.join.strip
          end.reject(&:empty?)
        end

        def cover_element(tag, extra_attrs, content)
          render_liquid("_element.html.liquid", {
                          "tag" => tag,
                          "extra_attrs" => extra_attrs,
                          "content" => content,
                        })
        end
      end
    end
  end
end
