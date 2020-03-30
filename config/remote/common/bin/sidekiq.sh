#!/bin/bash

cd /usr/local/rails_apps/Rails5Skeleton/current

/home/deploy/.rvm/bin/rvm default do bundle exec sidekiq -C /usr/local/rails_apps/Rails5Skeleton/current/config/sidekiq.yml -e staging
