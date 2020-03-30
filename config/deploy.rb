# config valid only for current version of Capistrano
lock "3.10.1"
require 'active_support/core_ext/string'
require_relative "deploy/aws_utils"
require_relative "deploy/server_sun_utils"

set :application, ENV["REPO_URL"].split("/").last.gsub(".git","").underscore.camelize
set :repo_url, ENV["REPO_URL"]

set :assets_roles, [:app]

set :deploy_ref, ENV["DEPLOY_REF"]
set :deploy_ref_type, ENV["DEPLOY_REF_TYPE"]
set :bundle_binstubs, ->{shared_path.join("bin")}

if fetch(:deploy_ref)
  set :branch, fetch(:deploy_ref)
else
  ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
end

platform = ENV["PLATFORM"] || "aws"
set :platform, platform
set :rvm_ruby_version, "2.4.1"

set :deploy_to, "/usr/local/rails_apps/#{fetch :application}"
set :deployer, ENV["DEPLOYER"] || "deploy"

set :instances, platform == "aws" ? get_ec2_targets : get_server_sun_targets

set :deploy_via,      :remote_cache
set :puma_state_file,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid_file,        "#{shared_path}/tmp/pids/puma.pid"

default_linked_files = [
  "config/database.yml",
  "config/secrets.yml",
  "config/application.yml"
]

append :linked_files, *default_linked_files

set :linked_dirs, %w(bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads)

namespace :deploy do
  desc "create database"
  task :create_database do
    on roles(:db) do |host|
      within release_path do
        with rails_env: ENV["RAILS_ENV"] do
          execute :rake, "db:create"
        end
      end
    end
  end
  before :migrate, :create_database

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        if test "[ -f #{fetch(:puma_pid_file)} ]" and test :kill, "-0 $( cat #{fetch(:puma_pid_file)} )"
          execute "sudo systemctl restart puma"
        else
          execute "sudo systemctl start puma"
        end
      end
    end

    on roles(:worker), in: :sequence, wait: 5 do
      within release_path do
        execute "sudo systemctl restart sidekiq"
      end
    end
  end
  after :publishing, :restart

  desc "update ec2 tags"
  task :update_ec2_tags do
    if fetch(:platform) == "aws"
      branch = fetch(:branch)
      ref_type = fetch(:deploy_ref_type)
      last_commit = fetch(:current_revision)
      update_ec2_tags ref_type, branch, last_commit
    end
  end
  after :restart, :update_ec2_tags
end
