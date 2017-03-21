# frozen_string_literal: true
class CreateBookSummaries < ActiveRecord::Migration[5.0]
  def change
    create_table :book_summaries, id: :uuid do |t|
      t.references :user, foreign_key: true, index: true, null: false
      t.string :book_isbn, null: false
      t.datetime :published_at
      t.integer :privacy_level, null: false, default: 0
      t.text :content

      t.timestamps
    end

    add_foreign_key :book_summaries, :book_infos, column: :book_isbn, primary_key: :isbn, on_delete: :restrict
    add_index :book_summaries, :published_at
  end
end
