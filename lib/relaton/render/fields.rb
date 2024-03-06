module Relaton
  module Render
    module Ogc
      class Fields < ::Relaton::Render::Fields
        def name_fields_format(hash)
          super
          hash[:publisher_abbrev] = hash[:publisher_abbrev_raw]&.join("/")
        end

        def draftformat(num, hash)
          return nil unless hash[:publisher] == "Open Geospatial Consortium"
          return nil unless num[:status]
          return nil if %w(approved published deprecated retired)
            .include?(num[:status])

          "(Draft)"
        end
      end
    end
  end
end
