# frozen_string_literal: true
class CreateBookBorrowings < ActiveRecord::Migration[5.0]
  def change
    create_table :book_borrowings, id: :uuid do |t|
      t.references :borrowing_trip, foreign_key: { to_table: :book_borrowing_trips },
                                    null: false, index: true, type: :uuid
      t.references :holding, foreign_key: { to_table: :book_holdings },
                             null: false, index: true, type: :uuid
      t.datetime :ended_at

      t.timestamps
    end
  end
end
