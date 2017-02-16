# frozen_string_literal: true
class DeviseCreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ""
      t.string :mobile, limit: 32
      t.string :encrypted_password, null: false, default: ""
      t.string :locale, limit: 8

      t.string :username, limit: 64
      t.string :name, null: false, limit: 64

      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      t.datetime :remember_created_at

      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      t.string   :mobile_confirmation_token
      t.datetime :mobile_confirmed_at
      t.datetime :mobile_confirmation_sent_at
      t.string   :unconfirmed_mobile, limit: 32

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :username, unique: true

    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
  end
end
