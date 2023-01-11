# frozen_string_literal: true

require "rgeo"
require "rgeo/proj4"

module Decidim
  module HomepageInteractiveMap
    # This class swaps the coordinates of a feature
    module CoordinatesSwapper
      def self.convert_geojson(geojson, opts = {})
        from = opts[:from] || detect_crs(geojson) || "EPSG:3857"
        to = opts[:to] || "EPSG:3857"

        geojson_clone = geojson.dup
        new_coordinates = transform(geojson_clone[:parsed_geometry][:geometry][:coordinates], from, to)
        new_geometry = geojson_clone[:parsed_geometry][:geometry].merge(coordinates: new_coordinates)
        new_parsed_geometry = geojson_clone[:parsed_geometry].merge(geometry: new_geometry)

        geojson_clone.merge(parsed_geometry: new_parsed_geometry)
      end

      def self.transform(coordinates, from = "EPSG:3943", to = "EPSG:3857")
        projection = RGeo::CoordSys::Proj4.create(from)
        geography = RGeo::CoordSys::Proj4.create(to)

        return transform_coords(projection, geography, coordinates.first, coordinates.last, nil) if coordinates.length == 2

        coordinates.map do |coord|
          if coord.first.is_a?(Array)
            transform(coord, from, to)
          else
            lat, lon = coord
            transform_coords(projection, geography, lat, lon, nil)
          end
        end
      end

      def self.transform_coords(projection, geography, lat, lon, alt)
        RGeo::CoordSys::Proj4.transform_coords(projection, geography, lat, lon, alt)
      end

      def self.detect_crs(geojson)
        geojson[:parsed_geometry][:crs][:properties][:name]
      end
    end
  end
end
