require_relative "init"
require "isodoc"

module IsoDoc
  module Ogc
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def example1(f)
        lbl = @xrefs.anchor(f['id'], :label, false) or return
        prefix_name(f, "&nbsp;&mdash; ", l10n("#{@example_lbl} #{lbl}"))
      end

      include Init
    end
  end
end

