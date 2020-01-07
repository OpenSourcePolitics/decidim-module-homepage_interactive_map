# frozen_string_literal: true

class AddGeolocationToParticipatoryProcesses < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_participatory_processes, :address, :string
    add_column :decidim_participatory_processes, :latitude, :float
    add_column :decidim_participatory_processes, :longitude, :float
  end
end
