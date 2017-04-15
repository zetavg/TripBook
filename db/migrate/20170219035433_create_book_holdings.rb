# frozen_string_literal: true
class CreateBookHoldings < ActiveRecord::Migration[5.0]
  def change
    create_table :book_holdings, id: :uuid do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.references :book, null: false, index: true, foreign_key: true, type: :uuid
      t.references :previous_holding, foreign_key: { to_table: :book_holdings }, index: false, type: :uuid
      t.string :state, limit: 32, null: false
      t.datetime :ready_for_released_at
      t.datetime :released_at

      t.timestamps
    end

    add_index :book_holdings, :state
    add_index :book_holdings, :previous_holding_id, unique: true

    reversible do |dir|
      dir.up do
        execute <<-EOL.strip_heredoc
          ALTER TABLE book_holdings
            ADD CONSTRAINT released_book_holdings_released_at CHECK (
              (
                book_holdings.state = 'released' AND
                book_holdings.released_at IS NOT NULL
              ) OR (
                book_holdings.state != 'released' AND
                book_holdings.released_at IS NULL
              )
            )
          ;
        EOL
        execute <<-EOL.strip_heredoc
          CREATE UNIQUE INDEX index_book_holdings_on_book_id_where_not_released ON book_holdings USING btree (book_id)
            WHERE book_holdings.state != 'released';
        EOL
        execute <<-EOL.strip_heredoc
          CREATE UNIQUE INDEX index_book_holdings_on_book_id_where_no_previous_holding_id ON book_holdings USING btree (book_id)
            WHERE book_holdings.previous_holding_id IS NULL;
        EOL
      end
    end
  end
end
