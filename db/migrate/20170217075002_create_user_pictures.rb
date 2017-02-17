# frozen_string_literal: true
class CreateUserPictures < ActiveRecord::Migration[5.0]
  def change
    create_table :user_pictures do |t|
      t.references :user, index: true, foreign_key: true
      t.string :image
      t.string :secure_token
      t.integer :width
      t.integer :height

      t.timestamps
    end

    add_index :user_pictures, :secure_token, unique: true
  end
end
