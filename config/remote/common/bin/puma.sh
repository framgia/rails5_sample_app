#!/bin/bash
# path : {rails_root}/config/remote/{env}/common/bin/puma.sh

APP_ROOT=/usr/local/rails_apps/current
/home/deploy/.rbenv/shims/bundle exec puma -C $APP_ROOT/config/remote/puma.rb
