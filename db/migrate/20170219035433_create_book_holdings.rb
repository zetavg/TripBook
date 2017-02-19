# frozen_string_literal: true
class CreateBookHoldings < ActiveRecord::Migration[5.0]
  def change
    create_table :book_holdings do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.references :book, null: false, index: true, foreign_key: true
      t.references :previous_holding, foreign_key: { to_table: :book_holdings }, index: true
      t.string :state, limit: 16, null: false
      t.datetime :ready_for_released_at
      t.datetime :released_at

      t.timestamps
    end

    add_index :book_holdings, :state
  end
end
