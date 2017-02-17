# frozen_string_literal: true
class CreateUserFacebookAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :user_facebook_accounts do |t|
      t.references :user, foreign_key: true
      t.string :facebook_id, null: false
      t.string :email
      t.string :name
      t.text :picture_url
      t.text :cover_photo_url
      t.text :access_token, null: false
      t.integer :access_token_expires_at, null: false

      t.timestamps
    end

    add_index :user_facebook_accounts, :facebook_id, unique: true
    add_index :user_facebook_accounts, :email
  end
end
