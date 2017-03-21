# frozen_string_literal: true
class CreateBookBorrowDemands < ActiveRecord::Migration[5.0]
  def change
    create_table :book_borrow_demands, id: :uuid do |t|
      t.references :user, foreign_key: true, index: true, null: false
      t.string :book_isbn, null: false
      t.string :state, limit: 32, null: false
      t.references :borrowing, foreign_key: { to_table: :book_borrowings }, index: true, type: :uuid

      t.timestamps
    end
  end
end
