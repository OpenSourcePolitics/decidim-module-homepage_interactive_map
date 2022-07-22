# frozen_string_literal: true

require "decidim/gem_manager"

# Copied from : https://github.com/Platoniq/decidim-module-decidim_awesome/blob/main/lib/tasks/decidim_awesome_webpacker_tasks.rake

namespace :decidim_homepage_interactive_map do
  namespace :webpacker do
    desc "Installs module's webpacker files in Rails instance application"
    task install: :environment do
      raise "Decidim gem is not installed" if decidim_path.nil?

      install_npm
    end

    desc "Adds JS dependencies in package.json"
    task upgrade: :environment do
      raise "Decidim gem is not installed" if decidim_path.nil?

      install_npm
    end

    def install_npm
      npm_dependencies.each do |type, packages|
        puts "install NPM packages. You can also do this manually with this command:"
        puts "npm i --save-#{type} #{packages.join(" ")}"
        system! "npm i --save-#{type} #{packages.join(" ")}"
      end
    end

    def npm_dependencies
      @npm_dependencies ||= begin
        package_json = JSON.parse(File.read(module_path.join("package.json")))

        {
          prod: package_json["dependencies"].map { |package, version| "#{package}@#{version}" }
        }.freeze
      end
    end

    def module_path
      @module_path ||= Pathname.new(module_gemspec.full_gem_path) if Gem.loaded_specs.has_key?(gem_name)
    end

    def module_gemspec
      @module_gemspec ||= Gem.loaded_specs[gem_name]
    end

    def rails_app_path
      @rails_app_path ||= Rails.root
    end

    def system!(command)
      system("cd #{rails_app_path} && #{command}") || abort("\n== Command #{command} failed ==")
    end

    def gem_name
      "decidim-homepage_interactive_map"
    end
  end
end
