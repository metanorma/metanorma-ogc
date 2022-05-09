module Relaton
  module Render
    class Date
      def render
        @date&.sub(/-.*$/, "")
      end
    end
  end
end
