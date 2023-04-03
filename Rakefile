# frozen_string_literal: true

require "decidim/dev/common_rake"
require "rgeo"
require "rgeo/proj4"

def external_seeds
  'load("../db/module_seeds.rb")'
end

def install_module(path)
  Dir.chdir(path) do
    system("bundle exec rake decidim_homepage_interactive_map:install:migrations")
    system("bundle exec rake db:migrate")
    File.write("db/seeds.rb", external_seeds, mode: "a")
  end
end

def setup_dependencies(path)
  Dir.chdir(path) do
    raise "You must install Proj4 to use this module, please check https://github.com/rgeo/rgeo-proj4" if `which proj` == ""
    raise "Proj4 was not setup properly please check README#install" unless RGeo::CoordSys::Proj4.supported?
  end
end

def seed_db(path)
  Dir.chdir(path) do
    system("bundle exec rake db:seed")
  end
end

desc "Generates a dummy app for testing"
task test_app: "decidim:generate_external_test_app" do
  ENV["RAILS_ENV"] = "test"
  setup_dependencies("spec/decidim_dummy_app")
  install_module("spec/decidim_dummy_app")
end

desc "Generates a development app"
task :development_app do
  Bundler.with_original_env do
    generate_decidim_app(
      "development_app",
      "--app_name",
      "#{base_app_name}_development_app",
      "--path",
      "..",
      "--recreate_db",
      "--demo"
    )
  end
  install_module("development_app")
  seed_db("development_app")
  setup_dependencies("development_app")
end
