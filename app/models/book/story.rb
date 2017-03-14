# frozen_string_literal: true
class Book::Story < ApplicationRecord
  enum privacy_level: {
    only_me: 0,
    only_by_invitation: 1,
    invitees_and_followers: 2,
    open_to_world: 3
  }

  scope :for, ->(user) { where(user: user) }

  belongs_to :user
  belongs_to :book_info, primary_key: :isbn, foreign_key: :book_isbn
  belongs_to :book,
             ->(o) { joins(:past_holders).where('users.id' => o.user_id).order('book_holdings.updated_at DESC') },
             primary_key: :isbn, foreign_key: :book_isbn, optional: true

  def publish
    published_at.present?
  end

  def publish=(publish)
    if parse_boolean(publish)
      self.published_at ||= Time.current
    else
      self.published_at = nil
    end
  end

  alias published? publish
end
