# frozen_string_literal: true

require "decidim/homepage_interactive_map/coordinates_swapper"

namespace :interactive_map do
  desc "Repair the interactive map data to ensure the geojson has a EPSG:3857 format"
  task repair_data: :environment do
    Decidim::Scope.where.not(geojson: nil).find_each do |scope|
      geojson = JSON.parse(scope.geojson, symbolize_names: true)
      new_geojson = Decidim::HomepageInteractiveMap::CoordinatesSwapper.convert_geojson(geojson)
      scope.update!(geojson: new_geojson.to_json)
    end
  end
end
