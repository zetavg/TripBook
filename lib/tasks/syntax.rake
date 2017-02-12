# frozen_string_literal: true
namespace :syntax do
  desc 'Fix frozen string error'
  task :auto_correct do
    sh 'bundle exec rubocop --auto-correct'
  end
end
