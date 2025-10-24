module Metanorma
  module Ogc
    class Converter < Standoc::Converter
      def schema_file
        "ogc.rng"
      end

      def title_validate(_root)
        nil
      end

      def content_validate(doc)
        super
        bibdata_validate(doc.root)
      end

      def bibdata_validate(doc)
        stage_validate(doc)
        version_validate(doc)
      end

      def stage_validate(xmldoc)
        @doctype == "engineering-report" and return
        stage = xmldoc&.at("//bibdata/status/stage")&.text
        %w(draft swg-draft oab-review public-rfc tc-vote work-item-draft
           approved deprecated retired rescinded legacy).include? stage or
          @log.add("OGC_1", nil, params: [stage])
        stage_type_validate(stage, @doctype)
      end

      def stage_type_validate(stage, doctype)
        case doctype
        when "standard", "abstract-specification-topic", "draft-standard"
          %w(draft work-item-draft).include?(stage)
        when "community-standard"
          %w(draft swg-draft).include?(stage)
        when "best-practice", "community-practice"
          %w(draft swg-draft work-item-draft).include?(stage)
        else %w(swg-draft oab-review public-rfc tc-vote work-item-draft
                deprecated rescinded legacy).include?(stage)
        end and
          @log.add("OGC_2", nil, params: [stage, doctype])
      end

      def version_validate(xmldoc)
        version = xmldoc.at("//bibdata/edition")&.text
        if %w(engineering-report discussion-paper).include? @doctype
          version.nil? or @log.add("OGC_3", nil, params: [@doctype])
        else
          version.nil? and @log.add("OGC_4", nil, params: [@doctype])
        end
      end

      def execsummary_validate(xmldoc)
        sect = xmldoc.at("//executivesummary")
        @doctype == "engineering-report" && sect.nil? and
          @log.add("OGC_5", nil)
        @doctype != "engineering-report" && !sect.nil? and
          @log.add("OGC_6", nil)
      end

      def section_validate(doc)
        preface_sequence_validate(doc.root)
        execsummary_validate(doc.root)
        sections_sequence_validate(doc.root)
        super
      end

      STANDARDTYPE = %w{standard standard-with-suite abstract-specification
                        community-standard profile}.freeze

      # spec of permissible section sequence
      # we skip normative references, it goes to end of list
      SEQ =
        [
          {
            msg: "Prefatory material must be followed by (clause) Scope",
            val: ["./self::clause[@type = 'scope']"],
          },
          {
            msg: "Scope must be followed by Conformance",
            val: ["./self::clause[@type = 'conformance']"],
          },
          {
            msg: "Normative References must be followed by " \
                 "Terms and Definitions",
            val: ["./self::terms | .//terms"],
          },
        ].freeze

      def seqcheck(names, msg, accepted)
        n = names.shift
        return [] if n.nil?

        test = accepted.map { |a| n.at(a) }
        if test.all?(&:nil?)
          @log.add("OGC_7", nil, params: [msg])
        end
        names
      end

      def sections_sequence_validate(root)
        STANDARDTYPE.include?(@doctype) or return
        names = root.xpath("//sections/* | //bibliography/*")
        names = seqcheck(names, SEQ[0][:msg], SEQ[0][:val])
        names = seqcheck(names, SEQ[1][:msg], SEQ[1][:val])
        names = seqcheck(names, SEQ[2][:msg], SEQ[2][:val])
        n = names.shift
        if n&.at("./self::definitions")
          n = names.shift
        end
        if n.nil? || n.name != "clause"
          @log.add("OGC_8", nil)
          return
        end
        root.at("//references | //clause[descendant::references]" \
                "[not(parent::clause)]") or
          @log.add("OGC_9", nil)
      end

      def preface_sequence_validate(root)
        @doctype == "engineering-report" and return
        root.at("//preface/abstract") or @log.add("OGC_10", nil)
        root.at("//bibdata/keyword | //bibdata/ext/keyword") or
          @log.add("OGC_11", nil)
        root.at("//foreword") or @log.add("OGC_12", nil)
        root.at("//bibdata/contributor[role/@type = 'author']/organization/" \
                "name") or
          @log.add("OGC_13", nil)
        root.at("//clause[@type = 'submitters' or @type = 'contributors']") or
          @log.add("OGC_14", nil)
      end

      def norm_ref_validate(doc)
        @doctype == "engineering-report" or return super
        doc.xpath("//references[@normative = 'true']").each do |b|
          @log.add("OGC_15", b)
        end
      end
    end
  end
end
