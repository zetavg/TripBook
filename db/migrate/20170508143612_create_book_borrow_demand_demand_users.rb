# frozen_string_literal: true
class CreateBookBorrowDemandDemandUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :book_borrow_demand_demand_users, id: :uuid do |t|
      t.references :borrow_demand, foreign_key: { to_table: :book_borrow_demands },
                                   null: false,
                                   type: :uuid
      t.references :user, foreign_key: true, null: false
      t.text :message

      t.timestamps
    end

    add_index :book_borrow_demand_demand_users, [:borrow_demand_id, :user_id],
              unique: true, name: 'index_book_borrow_demand_demand_users_on_b_d_id_and_u_id'
  end
end
