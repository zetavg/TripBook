# frozen_string_literal: true
namespace :docs do
  task :generate_erd do
    APP_ROOT = Pathname.new File.expand_path('../../../', __FILE__)

    chdir APP_ROOT do
      sh 'bundle exec rake erd notation=bachman inheritance=true polymorphism=false filetype=dot'
      sh 'dot -Tpng erd.dot -o erd.png'
    end

    puts "ERD diagram generated: #{APP_ROOT}/erd.png"
  end
end
