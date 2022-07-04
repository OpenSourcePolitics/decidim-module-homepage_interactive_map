# frozen_string_literal: true

module Decidim
  module HomepageInteractiveMap
    module InteractiveMapHelper
      def geolocation_enabled?
        Decidim::Map.available?(:geocoding)
      end

      def interactive_map_for(geojson, css_class = "row column")
        return unless geolocation_enabled?
        return if Decidim::Map.configuration[:api_key].blank?

        map_html_options = {
          class: "map",
          id: "interactive_map",
          "data-geojson-data" => geojson.to_json,
          "data-here-api-key" => Decidim::Map.configuration[:api_key]
        }
        content = capture { yield }.html_safe
        content_tag :div, class: css_class do
          content_tag(:div, "", map_html_options) + content
        end
      end

      def interactive_map_script(content_blocks)
        if content_blocks.map(&:manifest_name).include?("interactive_map") && content_blocks.map(&:manifest_name).include?("upcoming_meetings")
          "decidim/homepage_interactive_map/interactive_map_without_dependencies"
        elsif content_blocks.map(&:manifest_name).include?("interactive_map")
          "decidim/homepage_interactive_map/interactive_map"
        else
          ""
        end
      end
    end
  end
end
