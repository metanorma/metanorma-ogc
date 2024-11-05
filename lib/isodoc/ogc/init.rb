require "isodoc"
require_relative "metadata"
require_relative "xref"
require_relative "i18n"

module IsoDoc
  module Ogc
    module Init
      def metadata_init(lang, script, locale, labels)
        @meta = Metadata.new(lang, script, locale, labels)
      end

      def xref_init(lang, script, _klass, labels, options)
        html = HtmlConvert.new(language: lang, script: script)
        @xrefs = Xref.new(lang, script, html, labels, options)
      end

      def i18n_init(lang, script, locale, i18nyaml = nil)
        @i18n = I18n.new(lang, script, locale: locale,
                                       i18nyaml: i18nyaml || @i18nyaml)
      end

      def bibrenderer(options = {})
        ::Relaton::Render::Ogc::General.new(options.merge(language: @lang,
                                                          i18nhash: @i18n.get))
      end

      def fileloc(loc)
        File.join(File.dirname(__FILE__), loc)
      end

      def submittingorgs_path
        "//bibdata/contributor[role/@type = 'author']/organization/name"
      end
    end
  end
end
