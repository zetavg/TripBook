# frozen_string_literal: true
class CreateBookHoldingStoriesView < ActiveRecord::Migration[5.0]
  def up
    connection.execute %(
      CREATE OR REPLACE VIEW book_holding_stories AS
        SELECT
          "book_holdings"."id" AS holding_id,
          "book_holdings"."previous_holding_id" AS previous_holding_id,
          "book_holdings"."state" AS holding_state,
          "book_holdings"."book_id",
          "books"."owner_id" AS book_owner_id,
          "book_stories".*
        FROM "book_holdings"
        INNER JOIN "books" ON "book_holdings"."book_id" = "books"."id"
        INNER JOIN "book_stories" ON "book_stories"."book_isbn" = "books"."isbn"
          AND "book_stories"."user_id" = "book_holdings"."user_id"
      ;
    )
  end

  def down
    connection.execute "DROP VIEW IF EXISTS book_holding_stories;"
  end
end
