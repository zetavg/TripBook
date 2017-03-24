# frozen_string_literal: true
class CreateBookBorrowingInvitationInvitationUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :book_borrowing_invitation_invitation_users, id: :uuid do |t|
      t.references :borrowing_invitation, foreign_key: { to_table: :book_borrowing_invitations },
                                          null: false,
                                          index: {
                                            name: 'index_book_borrowing_invitation_invitation_users_on_b_o_id'
                                          },
                                          type: :uuid
      t.references :user, foreign_key: true, index: true
      t.string :state, limit: 32, null: false
      t.text :message

      t.timestamps
    end
  end
end
