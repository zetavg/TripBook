# frozen_string_literal: true
class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp'
    create_table :books, id: :uuid do |t|
      t.string :isbn
      t.references :owner, foreign_key: { to_table: :users }, null: false, index: true

      t.timestamps
    end

    add_index :books, :isbn
    add_foreign_key :books, :book_infos, column: :isbn, primary_key: :isbn, on_delete: :restrict
  end
end
