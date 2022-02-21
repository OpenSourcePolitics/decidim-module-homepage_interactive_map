# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module HomepageInteractiveMap
    # This is the engine that runs on the public interface of homepage_interactive_map.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::HomepageInteractiveMap

      routes do
        get "/data/polygon/:id", to: "data#polygon", as: :data_polygon
      end

      initializer "decidim_homepage_interactive_map.add_helper" do
        ActiveSupport.on_load :action_controller do
          helper Decidim::HomepageInteractiveMap::InteractiveMapHelper
        end
      end

      initializer "decidim_homepage_interactive_map.mount_routes" do |_app|
        Decidim::Core::Engine.routes do
          mount Decidim::HomepageInteractiveMap::Engine => "/homepage_interactive_map"
        end
      end

      initializer "decidim_homepage_interactive_map.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::HomepageInteractiveMap::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::HomepageInteractiveMap::Engine.root}/app/views") # for proposal partials
      end

      initializer "decidim_homepage_interactive_map.content_blocks" do
        Decidim.content_blocks.register(:homepage, :interactive_map) do |content_block|
          content_block.cell = "decidim/homepage_interactive_map/content_blocks/interactive_map"
          content_block.public_name_key = "decidim.homepage_interactive_map.content_blocks.interactive_map.name"
        end
      end

      initializer "decidim_homepage_interactive_map.assets" do |app|
        app.config.assets.precompile += %w(decidim_homepage_interactive_map_manifest.js decidim_homepage_interactive_map_manifest.css)
      end
    end
  end
end
