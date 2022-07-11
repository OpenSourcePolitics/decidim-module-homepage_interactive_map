# frozen_string_literal: true

namespace :decidim_homepage_interactive_map do
  desc "Install dependencies for decidim interactive maps"
  task initialize: :environment do
    puts "installing dependencies"
    system! "npm i --save proj4 proj4leaflet leaflet-tilelayer-here leaflet leaflet-svgicon leaflet.markercluster"
    system! "./bin/webpack"
  end
end
