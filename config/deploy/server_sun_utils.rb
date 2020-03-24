def get_server_sun_targets
  deploying_roles = ENV["DEPLOYING_ROLES"].split(",")
  YAML.load_file(ENV["SETTING_FILE"] || "config/deploy/settings.yml")["instance_ips"][ENV["RAILS_ENV"]]
      .select { |role_name, _| deploying_roles.include? role_name }
end
