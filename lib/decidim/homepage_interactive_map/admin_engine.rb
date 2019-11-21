# frozen_string_literal: true

module Decidim
  module HomepageInteractiveMap
    # This is the engine that runs on the public interface of `HomepageInteractiveMap`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::HomepageInteractiveMap::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :homepage_interactive_map do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "homepage_interactive_map#index"
      end

      def load_seed
        nil
      end
    end
  end
end
