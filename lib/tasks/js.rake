# frozen_string_literal: true
namespace :js do
  desc 'NPM install'
  task :install do
    sh 'bin/yarn install'
  end
end
