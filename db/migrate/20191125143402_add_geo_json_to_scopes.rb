class AddGeoJsonToScopes < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_scopes, :geojson, :jsonb
  end
end
