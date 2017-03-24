# frozen_string_literal: true
class CreateUserRecievedBookBorrowingInvitationsView < ActiveRecord::Migration[5.0]
  def up
    connection.execute %(
      CREATE OR REPLACE VIEW user_recieved_book_borrowing_invitations AS
        SELECT
          "book_holdings"."user_id" AS inviter_id,
          "book_borrowing_invitation_invitation_users"."user_id",
          "book_holdings"."state" AS holding_state,
          "book_borrowing_invitation_invitation_users"."state" AS state,
          "book_holdings"."book_id" AS book_id,
          "books"."isbn" AS book_isbn,
          "book_stories"."id" AS story_id,
          "book_borrowing_invitations"."id" AS id,
          "book_borrowing_invitation_invitation_users"."message"
        FROM "book_borrowing_invitations"
        INNER JOIN "book_borrowing_invitation_invitation_users"
          ON "book_borrowing_invitation_invitation_users"."borrowing_invitation_id" = "book_borrowing_invitations"."id"
        INNER JOIN "book_holdings"
          ON "book_holdings"."id" = "book_borrowing_invitations"."holding_id"
        INNER JOIN "books"
          ON "books"."id" = "book_holdings"."book_id"
        INNER JOIN "book_stories"
          ON "book_stories"."book_isbn" = "books"."isbn"
          AND "book_stories"."user_id" = "book_holdings"."user_id"
      ;
    )
  end

  def down
    connection.execute "DROP VIEW IF EXISTS user_recieved_book_borrowing_invitations;"
  end
end
