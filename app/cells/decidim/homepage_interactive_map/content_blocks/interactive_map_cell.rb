# frozen_string_literal: true
require "json"

module Decidim
  module HomepageInteractiveMap
    module ContentBlocks
      class InteractiveMapCell < Decidim::ViewModel
        helper_method :assemblies_data_for_map
        include Decidim::HomepageInteractiveMap::InteractiveMapHelper

        def geolocalized_assemblies
          @geolocalized_assemblies ||= Decidim::Assembly.where(organization: current_organization).where(scope: geolocalized_scopes).published
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
              participatory_processes: participatory_processes_data_for_map(assembly)
          )
        end

        def participatory_processes_data_for_map(assembly)
          participatory_processes(assembly).map do |participatory_process|
            participatory_process_data_for_map(participatory_process)
          end
        end

        def participatory_process_data_for_map(participatory_process)
          {
              title: translated_attribute(participatory_process.title),
              start_date: l(participatory_process.start_date, format: :decidim_short),
              end_date: l(participatory_process.end_date, format: :decidim_short),
              link: participatory_process_path(participatory_process)
          }
        end

        def participatory_processes(assembly)
          assembly.linked_participatory_space_resources(:participatory_processes, "included_participatory_processes").select { |participatory_process| participatory_process if (participatory_process.published? && participatory_process.active?) }
        end

        def participatory_process_path(participatory_process)
          Decidim::EngineRouter.main_proxy(participatory_process).participatory_process_path(participatory_process)
        end

        def assembly_path(assembly)
          Decidim::EngineRouter.main_proxy(assembly).assembly_path(assembly)
        end
      end
    end
  end
end
