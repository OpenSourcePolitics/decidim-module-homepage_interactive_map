# frozen_string_literal: true

require "decidim/homepage_interactive_map/coordinates_swapper"

namespace :decidim_homepage_interactive_map do
  desc "Repair the interactive map data to ensure the geojson has a EPSG:3857 format"
  task repair_data: :environment do
    Decidim::Scope.where.not(geojson: nil).find_each do |scope|
      scope.update!(geojson: Decidim::HomepageInteractiveMap::CoordinatesSwapper.convert_geojson(scope.geojson))
    end
  end

  task check_for_repair: :environment do
    puts "Checking for scopes with wrong geojson format"
    scopes = Decidim::Scope.where.not(geojson: nil).select do |scope|
      Decidim::HomepageInteractiveMap::CoordinatesSwapper.detect_crs(scope.geojson) != "EPSG:4326"
    end

    if scopes.any?
      puts "Found #{scopes.count} scopes with wrong geojson format"
      puts "Run `rake decidim_homepage_interactive_map:repair_data` to fix them"
    else
      puts "All scopes have the correct geojson format"
    end
  end
end
