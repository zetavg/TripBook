# frozen_string_literal: true
class CreateBookInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :book_infos, id: false do |t|
      t.string :isbn, limit: 32, null: false, primary_key: true
      t.string :isbn_10, limit: 32
      t.string :isbn_13, limit: 32
      t.string :name, limit: 128, null: false
      t.string :language, limit: 64
      t.string :author, limit: 64
      t.string :publisher, limit: 64
      t.date :publish_date

      t.timestamps
    end

    add_index :book_infos, :isbn, unique: true
    add_index :book_infos, :isbn_10, unique: true
    add_index :book_infos, :isbn_13, unique: true
  end
end
