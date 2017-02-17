# frozen_string_literal: true
namespace :syntax do
  task :check do
    sh 'bin/rubocop'
  end

  task :check_js do
    sh './node_modules/.bin/eslint app/assets/javascripts/'
  end

  task :auto_correct do
    sh 'bin/rubocop --auto-correct'
  end
end
