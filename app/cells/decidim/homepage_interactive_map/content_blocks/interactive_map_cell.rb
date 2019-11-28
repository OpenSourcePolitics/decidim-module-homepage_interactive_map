# frozen_string_literal: true
require "json"

module Decidim
  module HomepageInteractiveMap
    module ContentBlocks
      class InteractiveMapCell < Decidim::ViewModel
        helper_method :assemblies_data_for_map
        include Decidim::HomepageInteractiveMap::InteractiveMapHelper

        def geolocalized_assemblies
          @geolocalized_assemblies ||= Decidim::Assembly.where(organization: current_organization).where(scope: geolocalized_scopes)
        end

        private

        def assemblies_data_for_map(geolocalized_assemblies)
          geolocalized_assemblies.map do |assembly|
            assembly_data_for_map(assembly)
          end
        end

        def geolocalized_scopes
          current_organization.scopes.where.not(geojson: nil)
        end

        def assembly_data_for_map(assembly)
          assembly.scope.geojson["parsed_geometry"].merge(
              color: assembly.scope.geojson["color"],
              link: assembly_path(assembly),
              participatory_processes: assembly.linked_participatory_space_resources(:participatory_processes, "included_participatory_processes")
          )
        end

        def assembly_path(assembly)
          Decidim::EngineRouter.main_proxy(assembly).assembly_path(assembly)
        end
      end
    end
  end
end
