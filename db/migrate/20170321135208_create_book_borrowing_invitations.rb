# frozen_string_literal: true
class CreateBookBorrowingInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :book_borrowing_invitations, id: :uuid do |t|
      t.references :holding, foreign_key: { to_table: :book_holdings }, null: false, index: true, type: :uuid
      t.references :created_borrowing, foreign_key: { to_table: :book_borrowings }, index: true, type: :uuid

      t.timestamps
    end
  end
end
