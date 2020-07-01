require "isodoc"
require_relative "metadata"
require_relative "xref"

module IsoDoc
  module Ogc
    module Init
      def metadata_init(lang, script, labels)
        @meta = Metadata.new(lang, script, labels)
      end

      def xref_init(lang, script, klass, labels, options)
        @xrefs = Xref.new(lang, script, HtmlConvert.new(language: lang, script: script), labels, options)
      end

      def load_yaml(lang, script)
        y = if @i18nyaml then YAML.load_file(@i18nyaml)
            else
              YAML.load_file(File.join(File.dirname(__FILE__), "i18n-en.yaml"))
            end
        super.merge(y)
      end

      def submittingorgs_path
        "//bibdata/contributor[role/@type = 'author']/organization/name"
      end
    end
  end
end

