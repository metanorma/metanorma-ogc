module Relaton
  module Render
    module Ogc
      class Date
        def render
          @type == "accessed" or @date&.sub(/-.*$/, "")
          @date
        end
      end
    end
  end
end
