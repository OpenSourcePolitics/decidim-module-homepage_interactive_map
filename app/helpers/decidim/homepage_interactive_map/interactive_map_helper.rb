# frozen_string_literal: true

module Decidim
  module HomepageInteractiveMap
    module InteractiveMapHelper
      def interactive_map_for(geoJson, css_class = "row column")
        return if Rails.application.secrets.geocoder.blank?

        map_html_options = {
            class: "google-map",
            id: "interactive_map",
            "data-geojson-data" => geoJson.to_json,
            "data-here-app-id" => Rails.application.secrets.geocoder[:here_app_id],
            "data-here-app-code" => Rails.application.secrets.geocoder[:here_app_code]
        }
        content = capture { yield }.html_safe
        content_tag :div, class: css_class do
          content_tag(:div, "", map_html_options) + content
        end
      end
    end
  end
end
