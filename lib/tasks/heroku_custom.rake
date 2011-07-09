require File.dirname( __FILE__ ) + '/../../config/environment'
require 'shell'

include Shell

TARGETS = %w[ production staging ]

namespace :heroku do

  desc "Back up DB from production to localhost"
  task :backup => %w[ heroku:pull db:backup ]

  desc "Clone DB from production to localhost"
  task :pull do
    target = ENV['TARGET'] || TARGETS.first
    execute "rake db:drop db:create RAILS_ENV=#{Rails.env}"
    execute "heroku db:pull --app #{app}-#{target} --confirm #{app}-#{target}"
  end

  desc "Clone DB from production to localhost"
  task :push do
    target = ENV['TARGET'] || raise( 'please pass in TARGET')
    raise 'Refusing to push db to production' if target=='prod' || target=='production'
    execute "heroku rake db:reset --app #{app}-#{target}"
    execute "heroku db:push --app #{app}-#{target} --confirm #{app}-#{target}"
  end

  desc "Deploy from REF=<ref> TARGET=<#{TARGETS.join('|')}>"
  task :deploy => :environment do
    ref = ENV['REF'] || 'master'
    target = ENV['TARGET'] || TARGETS.first
    deploy( target, ref )
    execute( "heroku rake --trace db:migrate                 --app #{app}-#{target}" )
    execute( "heroku restart                                 --app #{app}-#{target}" )
    execute( "heroku rake --trace db:seed                    --app #{app}-#{target}" )
  end

  def deploy( target, ref )
    # add remote in case this dev box doesn't have it yet, makes it easier to track, eg in gitx
    git_remote = "heroku-#{app}-#{target}"
    unless `git remote`.match( /\b#{git_remote}\b/ )
      execute( "git remote add #{git_remote} git@heroku.com:#{app}-#{target}.git" )
    end

    # deploy release branch: always *to* heroku "master" branch
    execute( "git push --force #{git_remote} #{ref}:master" )
  end

  desc 'make new app instance on heroku using TARGET=<eg static1>'
  task :create do
    the_name = ENV[ 'TARGET' ] || raise( 'Please pass in TARGET=<eg static1>' )
    heroku_app = "#{app}-#{the_name}"
    [
      "heroku create #{heroku_app} --stack bamboo-mri-1.9.2",
      "heroku addons:add custom_domains --app #{heroku_app}",
    ].each { |cmd| execute( cmd, :continue_on_failure => true ) }

    execute( "heroku domains:add #{the_name}.#{app}.org --app #{heroku_app}", :confirm_first => true )
  end

  def app
    ENV[ 'APP' ] || File.expand_path( Rails.root ).split( '/' ).last
  end

end
