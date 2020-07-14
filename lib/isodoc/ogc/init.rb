require "isodoc"
require_relative "metadata"
require_relative "xref"
require_relative "i18n"

module IsoDoc
  module Ogc
    module Init
      def metadata_init(lang, script, labels)
        @meta = Metadata.new(lang, script, labels)
      end

      def xref_init(lang, script, klass, labels, options)
        html = HtmlConvert.new(language: lang, script: script)
        @xrefs = Xref.new(lang, script, html, labels, options)
      end

      def i18n_init(lang, script, i18nyaml = nil)
        @i18n = I18n.new(lang, script, i18nyaml || @i18nyaml)
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

