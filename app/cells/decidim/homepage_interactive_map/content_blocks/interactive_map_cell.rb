# frozen_string_literal: true
require "json"

module Decidim
  module HomepageInteractiveMap
    module ContentBlocks
      class InteractiveMapCell < Decidim::ViewModel
        def geolocalized_scopes
          @geolocalized_scopes ||= current_organization.scopes.where.not(geojson: nil).pluck(:geojson).to_json
        end
      end
    end
  end
end
