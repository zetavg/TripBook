# frozen_string_literal: true
class EnableUUID < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp'
  end
end
