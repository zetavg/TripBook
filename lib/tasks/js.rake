# frozen_string_literal: true
namespace :js do
  desc 'NPM install'
  task :install do
    sh 'npm install'
  end
end
