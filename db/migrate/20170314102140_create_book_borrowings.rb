# frozen_string_literal: true
class CreateBookBorrowings < ActiveRecord::Migration[5.0]
  def change
    create_table :book_borrowings do |t|
      t.references :book_borrowing_trip, null: false, index: true, foreign_key: true, type: :uuid
      t.references :book_holding, null: false, index: true, foreign_key: true, type: :uuid
      t.datetime :ended_at

      t.timestamps
    end
  end
end
