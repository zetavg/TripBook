# frozen_string_literal: true
source 'https://rubygems.org'

ruby '2.7.2'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use PostgreSQL as the database for Active Record
gem 'pg'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Console
gem 'pry-rails'
gem 'hirb'
gem 'awesome_print'

# Configuration
gem 'settingslogic'

# Model Utils
gem 'active_type'
gem 'aasm'
gem 'paper_trail'

# User Authentication
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'

# File Storage
gem 'carrierwave'
gem 'fog'

# Image Processor
gem 'mini_magick'

# Paging
gem 'kaminari'

# Front-end
gem 'slim-rails'
gem 'simple_form'
gem 'jbuilder', '~> 2.5'
gem 'sass-rails'
gem 'bootstrap', '~> 4.0.0.alpha6'
gem 'sprockets-commoner'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'tether-rails'
gem 'select2-rails'
gem 'jquery-fileupload-rails'

# Administration
gem 'activeadmin', '~> 1.0.0.pre5'
gem 'inherited_resources', github: 'activeadmin/inherited_resources'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Monitor
gem 'newrelic_rpm'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  gem 'dotenv-rails'

  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'shoulda'
  gem 'faker'
  gem 'timecop'
  gem 'database_rewinder'

  gem 'simplecov', require: false
  gem 'coveralls', require: false

  gem 'rails-erd'
  gem 'rubocop', require: false
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'

  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'sassc-rails'

  gem 'bullet'

  gem 'guard', require: false
  gem 'guard-rspec', require: false
  gem 'guard-livereload', '~> 2.5.2', require: false

  gem 'rack-livereload'
  gem 'letter_opener'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
