require "rvm/capistrano"
require "bundler/capistrano"
load "deploy/assets"

set :ssh_options, :auth_methods => ["publickey"],
  :keys => ["../infrastructure/keys/linode"]

default_run_options[:pty] = true  # Must be set for the password prompt
                                  # from git to work

set :repository, "git@github.com:goggin13/word-tracker.git"  # Your clone URL
set :branch, "master"
set :scm, "git"
set :user, "goggin"  # The server"s user for deploys
set :deploy_via, :remote_cache
set :application, "word-tracker"
set :deploy_to, "/home/goggin/projects/word-tracker"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "li572-168.members.linode.com"                          # Your HTTP server, Apache/etc
role :app, "li572-168.members.linode.com"                          # This may be the same as your `Web` server
role :db,  "li572-168.members.linode.com", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

set :rails_env, "production"
set :keep_releases, 5
set :rvm_ruby_string, :local

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# if you"re still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,"tmp","restart.txt")}"
#   end
# end

namespace :deploy do

  desc "Restart Passenger app"
  task :restart do
    run "rvm current"
    run "#{ try_sudo } touch #{ File.join(current_path, "tmp", "restart.txt") }"
  end
end
