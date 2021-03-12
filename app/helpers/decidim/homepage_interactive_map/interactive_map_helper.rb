# frozen_string_literal: true

module Decidim
  module HomepageInteractiveMap
    module InteractiveMapHelper

      def geolocation_enabled?
        Decidim::Map.available?(:geocoding)
      end

      def interactive_map_for(geojson, css_class = "row column")
        return if Rails.application.secrets.maps.blank?

        map_html_options = {
          class: "map",
          id: "interactive_map",
          "data-geojson-data" => geojson.to_json,
          "data-here-api-key" => Rails.application.secrets.maps[:api_key]
        }
        content = capture { yield }.html_safe
        content_tag :div, class: css_class do
          content_tag(:div, "", map_html_options) + content
        end
      end
    end
  end
end
