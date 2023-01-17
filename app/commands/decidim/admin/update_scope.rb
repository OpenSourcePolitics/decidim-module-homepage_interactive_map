# frozen_string_literal: true

require "decidim/homepage_interactive_map/coordinates_swapper"

module Decidim
  module Admin
    # A command with all the business logic when updating a scope.
    class UpdateScope < Rectify::Command
      # Public: Initializes the command.
      #
      # scope - The Scope to update
      # form - A form object with the params.
      def initialize(scope, form)
        @scope = scope
        @form = form
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) if form.invalid?

        update_scope
        broadcast(:ok)
      end

      private

      attr_reader :form

      def update_scope
        Decidim.traceability.update!(
          @scope,
          form.current_user,
          attributes,
          extra: {
            parent_name: @scope.parent.try(:name),
            scope_type_name: form.scope_type.try(:name)
          }
        )
      end

      def attributes
        {
          name: form.name,
          code: form.code,
          geojson: Decidim::HomepageInteractiveMap::CoordinatesSwapper.convert_geojson(geojson),
          scope_type: form.scope_type
        }
      end

      def geojson
        return nil if form.geolocalized.blank?

        {
          color: form.geojson[:color],
          geometry: form.geojson[:geometry],
          parsed_geometry: form.geojson[:parsed_geometry]
        }
      end
    end
  end
end
