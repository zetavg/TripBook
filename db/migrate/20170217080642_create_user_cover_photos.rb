# frozen_string_literal: true
class CreateUserCoverPhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :user_cover_photos do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.string :image
      t.string :secure_token
      t.integer :width
      t.integer :height

      t.timestamps
    end

    add_index :user_cover_photos, :secure_token, unique: true
  end
end
