# frozen_string_literal: true
require "json"

module Decidim
  module HomepageInteractiveMap
    module ContentBlocks
      class InteractiveMapCell < Decidim::ViewModel
        def geojson_data
          geolocalized_scopes.map do |scope|
            scope.geojson.merge(scope: scope)
          end.to_json
        end

        private

        def geolocalized_scopes
          @geolocalized_scopes ||= current_organization.scopes.where.not(geojson: nil)
        end
      end
    end
  end
end
