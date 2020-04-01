#!/bin/bash

cd /usr/local/rails_apps/Rails5Skeleton/current

/home/deploy/.rvm/bin/rvm default do bundle exec puma -C /usr/local/rails_apps/Rails5Skeleton/shared/config/puma.rb
