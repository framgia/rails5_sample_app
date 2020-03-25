require_relative 'boot'

require 'rails/all'
require 'active_support/core_ext/string'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

eval(<<EOF
module #{(`echo $REPO_URL`.gsub("\n", "").presence || Dir.pwd).split("/").last.gsub(".git","").underscore.camelize}	
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Asia/Tokyo'
    config.active_record.default_timezone = :local
    config.active_record.time_zone_aware_attributes = false

    config.autoload_paths += Dir[Rails.root.join("lib").to_s]
    config.eager_load_paths += Dir[Rails.root.join("lib").to_s]

    Dir.glob("config/routes/*").each do |route|
      config.paths["config/routes.rb"] << Rails.root.join(route)
    end
  end
end
EOF
)
