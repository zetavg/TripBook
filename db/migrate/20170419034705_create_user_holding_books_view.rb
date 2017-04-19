# frozen_string_literal: true
class CreateUserHoldingBooksView < ActiveRecord::Migration[5.0]
  def up
    connection.execute %(
      CREATE OR REPLACE VIEW user_holding_books AS
        SELECT
          DISTINCT ON (books.id, book_holdings.user_id) books.*,
          book_holdings.id AS holding_id,
          book_holdings.user_id,
          book_holdings.state AS holding_state,
          book_holdings.updated_at AS holding_updated_at,
          book_holdings.created_at AS holding_created_at
        FROM "books"
        INNER JOIN "book_holdings"
          ON "book_holdings"."book_id" = "books"."id"
        ORDER BY books.id, book_holdings.user_id, holding_created_at DESC
      ;
    )
  end

  def down
    connection.execute "DROP VIEW IF EXISTS user_holding_books;"
  end
end
