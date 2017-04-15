# frozen_string_literal: true
class CreateBookBorrowingTrips < ActiveRecord::Migration[5.0]
  def change
    create_table :book_borrowing_trips, id: :uuid do |t|
      t.references :holding, foreign_key: { to_table: :book_holdings }, index: true, type: :uuid
      t.string :state, limit: 32
      t.integer :max_single_durition_days
      t.integer :max_durition_days
      t.integer :max_borrowings_count
      t.integer :borrowings_count, null: false, default: 0
      t.datetime :ended_at

      t.timestamps
    end

    add_index :book_borrowing_trips, :state
  end
end
