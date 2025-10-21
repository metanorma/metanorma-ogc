module Metanorma
  module Ogc
    class Converter
      OGC_LOG_MESSAGES = {
        # rubocop:disable Naming/VariableNumber
        "OGC_1": { category: "Document Attributes",
                   error: "%s is not a recognised status",
                   severity: 2 },
        "OGC_2": { category: "Document Attributes",
                   error: "%s is not an allowed status for %s",
                   severity: 2 },
        "OGC_3": { category: "Document Attributes",
                   error: "Version not permitted for %s",
                   severity: 2 },
        "OGC_4": { category: "Document Attributes",
                   error: "Version required for %s",
                   severity: 2 },
        "OGC_5": { category: "Style",
                   error: "Executive Summary required for Engineering Reports!",
                   severity: 2 },
        "OGC_6": { category: "Style",
                   error: "Executive Summary only allowed for Engineering Reports!",
                   severity: 2 },
        "OGC_7": { category: "Style",
                   error: "(section sequencing) %s",
                   severity: 2 },
        "OGC_8": { category: "Style",
                   error: "Document must contain at least one clause",
                   severity: 2 },
        "OGC_9": { category: "Style",
                   error: "Normative References are mandatory",
                   severity: 2 },
        "OGC_10": { category: "Style",
                    error: "Abstract is missing!",
                    severity: 2 },
        "OGC_11": { category: "Style",
                    error: "Keywords are missing!",
                    severity: 2 },
        "OGC_12": { category: "Style",
                    error: "Preface is missing!",
                    severity: 2 },
        "OGC_13": { category: "Style",
                    error: "Submitting Organizations is missing!",
                    severity: 2 },
        "OGC_14": { category: "Style",
                    error: "Submitters is missing!",
                    severity: 2 },
        "OGC_15": { category: "Bibliography",
                    error: "Engineering report should not contain normative references",
                    severity: 2 },
        "OGC_16": { category: "Document Attributes",
                    error: "'%s' is not a legal document type: reverting to 'standard'",
                    severity: 2 },
        "OGC_17": { category: "Document Attributes",
                    error: "'%s' is not a permitted subtype of Standard: reverting to 'implementation'",
                    severity: 2 },
        "OGC_18": { category: "Document Attributes",
                    error: "'%s' is not a permitted subtype of best-practice: reverting to 'general'",
                    severity: 2 },
      }.freeze
      # rubocop:enable Naming/VariableNumber

      def log_messages
        super.merge(OGC_LOG_MESSAGES)
      end
    end
  end
end
