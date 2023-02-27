# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/homepage_interactive_map/version"

Gem::Specification.new do |s|
  s.version = Decidim::HomepageInteractiveMap::VERSION
  s.authors = ["Armand"]
  s.email = ["fardeauarmand@gmail.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-homepage_interactive_map"
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-homepage_interactive_map"
  s.summary = "A decidim homepage_interactive_map module"
  s.description = "Displays an interactive map on homepage."

  s.files = Dir["{app,config,lib,vendor}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md", "package.json"]

  s.post_install_message = <<-MESSAGE
Decidim Homepage Interactive map needs dependencies to be installed.
Please have a look at https://github.com/OpenSourcePolitics/decidim-module-homepage_interactive_map/blob/release/0.26-stable/README.md#installation
MESSAGE


  s.add_dependency "decidim-admin", Decidim::HomepageInteractiveMap::COMPAT_DECIDIM_VERSION
  s.add_dependency "decidim-core", Decidim::HomepageInteractiveMap::COMPAT_DECIDIM_VERSION
  s.add_dependency "decidim-dev", Decidim::HomepageInteractiveMap::COMPAT_DECIDIM_VERSION
  s.add_dependency "rgeo", "~> 2.4"
  s.add_dependency "rgeo-proj4", "~> 3.1"
end
