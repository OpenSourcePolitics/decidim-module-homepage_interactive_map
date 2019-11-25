# frozen_string_literal: true
require "json"

module Decidim
  module HomepageInteractiveMap
    module ContentBlocks
      class InteractiveMapCell < Decidim::ViewModel
        def data_geojson
          geolocalized_scopes.map { |scope| scope.geojson }.to_json
        end

        private

        def geolocalized_scopes
          @geolocalized_scopes ||= current_organization.scopes.where.not(geojson: nil)
        end
      end
    end
  end
end
