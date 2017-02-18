# frozen_string_literal: true
class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :isbn
      t.references :owner, foreign_key: { to_table: :users }, null: false, index: true

      t.timestamps
    end

    add_index :books, :isbn
  end
end
