# frozen_string_literal: true
class Book::ReadingCompletion < ActiveType::Object
  nests_one :user, scope: proc { User.all }
  nests_one :book, scope: proc { Book.all }

  attribute :story_content, :string
  attribute :story_privacy_level, :string

  validates :user, :book, presence: true

  before_save :update_user_book_story
  before_save :mark_book_holding_to_ready_for_realease

  private

  def validate_invitation_invites_user
    return if invitation.invitees.include?(user)
    errors.add(:invitation, "illegal")
    errors.add(:user, "illegal")
  end

  def update_user_book_story
    @book_story = user.book_stories.for_isbn(book.isbn).first_or_create!
    @book_story.assign_attributes(
      publish: true,
      content: story_content,
      privacy_level: story_privacy_level
    )
    @book_story.save!
  end

  def mark_book_holding_to_ready_for_realease
    @book_holding = book.holdings.where(user: user).holding.last
    return unless @book_holding.present?
    @book_holding.ready_for_release!
  end
end
