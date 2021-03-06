puts "Adding configs for Heroku"

gem 'rails_12factor'

gem 'puma'

file "Procfile", <<-CODE
web: bundle exec puma -C config/puma.rb
CODE

file "config/puma.rb", <<-CODE
workers Integer(ENV['WEB_CONCURRENCY'] || 1)
threads_count = Integer(ENV['MAX_THREADS'] || 1)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do

  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot

  # Not using ActiveRecord
  # ActiveRecord::Base.establish_connection

  # if defined?(Resque)
  #    Resque.redis = ENV["<redis-uri>"] || "redis://127.0.0.1:6379"
  # end
end
CODE

run "bundle"

# Create a new Heroku app with the application name
puts <<-OUTPUT
**************************************
Now run:
heroku create #{Rails.application.class.to_s.split('::').first.underscore.dasherize}
OUTPUT
