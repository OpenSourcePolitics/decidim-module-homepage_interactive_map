# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/proposals/test/factories"
require "decidim/participatory_processes/test/factories"

FactoryBot.define do
  factory :homepage_interactive_map_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :homepage_interactive_map).i18n_name }
    manifest_name { :homepage_interactive_map }
    participatory_space { create(:participatory_process, :with_steps) }
  end
end

FactoryBot.modify do
  factory :participatory_process, class: "Decidim::ParticipatoryProcess" do
    address { Faker::Lorem.sentence(3) }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
