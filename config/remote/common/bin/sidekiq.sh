#!/bin/bash

APP_ROOT=/usr/local/rails_apps/current

cd $APP_ROOT
#!/bin/bash

APP_ROOT=/usr/local/rails_apps/current
/home/deploy/.rbenv/shims/bundle exec sidekiq -C $APP_ROOT/config/sidekiq.yml
