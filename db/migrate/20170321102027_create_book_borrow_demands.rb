# frozen_string_literal: true
class CreateBookBorrowDemands < ActiveRecord::Migration[5.0]
  def change
    create_table :book_borrow_demands, id: :uuid do |t|
      t.references :user, foreign_key: true, index: true, null: false
      t.string :book_isbn, null: false
      t.string :state, limit: 32, null: false
      t.text :message
      t.references :borrowing, foreign_key: { to_table: :book_borrowings }, index: true, type: :uuid

      t.timestamps
    end

    add_foreign_key :book_borrow_demands, :book_infos, column: :book_isbn, primary_key: :isbn, on_delete: :restrict
    add_index :book_borrow_demands, [:user_id, :book_isbn], unique: true
  end
end
