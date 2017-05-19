I18n.load_path += Dir["#{Rails.root.to_s}/config/locales/**/*.{rb,yml}"] if eval(ENV["IS_API_SERVICE"])
