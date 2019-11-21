# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/homepage_interactive_map/version"

Gem::Specification.new do |s|
  s.version = Decidim::HomepageInteractiveMap.version
  s.authors = ["Armand"]
  s.email = ["fardeauarmand@gmail.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-homepage_interactive_map"
  s.required_ruby_version = ">= 2.5"

  s.name = "decidim-homepage_interactive_map"
  s.summary = "A decidim homepage_interactive_map module"
  s.description = "Displays an interactive map on homepage."

  s.files = Dir["{app,config,lib,vendor}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::HomepageInteractiveMap.version
  s.add_dependency "decidim-admin", Decidim::HomepageInteractiveMap.version
  s.add_dependency "decidim-dev", Decidim::HomepageInteractiveMap.version
end
