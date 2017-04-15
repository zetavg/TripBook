# frozen_string_literal: true
class CreateUserProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :user_profiles, id: :uuid do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :gender, limit: 2
      t.integer :birthday_year, limit: 8
      t.integer :birthday_month, limit: 2
      t.integer :birthday_day, limit: 2

      t.timestamps
    end
  end
end
