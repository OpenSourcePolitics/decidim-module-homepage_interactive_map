# frozen_string_literal: true

require "decidim/homepage_interactive_map/coordinates_swapper"

namespace :decidim_homepage_interactive_map do
  desc "Repair the interactive map data to ensure the geojson has a EPSG:3857 format"
  task repair_data: :environment do
    Decidim::Scope.where.not(geojson: nil).find_each do |scope|
      scope.update!(geojson: Decidim::HomepageInteractiveMap::CoordinatesSwapper.convert_geojson(scope.geojson))
    end
  end
end
