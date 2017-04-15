# frozen_string_literal: true
class CreateBookBorrowingTrips < ActiveRecord::Migration[5.0]
  def change
    create_table :book_borrowing_trips, id: :uuid do |t|
      t.references :holding, foreign_key: { to_table: :book_holdings }, index: true, null: false, type: :uuid
      t.string :state, limit: 32
      t.integer :max_single_durition_days
      t.integer :max_durition_days
      t.integer :max_borrowings_count
      t.integer :borrowings_count, null: false, default: 0
      t.datetime :ended_at

      t.timestamps
    end

    add_index :book_borrowing_trips, :state

    reversible do |dir|
      dir.up do
        execute <<-EOL.strip_heredoc
          ALTER TABLE book_borrowing_trips
            ADD CONSTRAINT ended_book_borrowing_trips_ended_at CHECK (
              (
                book_borrowing_trips.state = 'ended' AND
                book_borrowing_trips.ended_at IS NOT NULL
              ) OR (
                book_borrowing_trips.state != 'ended' AND
                book_borrowing_trips.ended_at IS NULL
              )
            )
          ;
        EOL
        execute <<-EOL.strip_heredoc
          CREATE UNIQUE INDEX index_book_borrowing_trips_on_holding_id_where_not_ended ON book_borrowing_trips USING btree (holding_id)
            WHERE book_borrowing_trips.state != 'ended';
        EOL
      end
    end
  end
end
