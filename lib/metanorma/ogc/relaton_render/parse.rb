module Relaton
  module Render
    module Ogc
      class Parse < ::Relaton::Render::Parse
        def creatornames_roles_allowed
          %w(author performer adapter translator editor)
        end
      end
    end
  end
end
