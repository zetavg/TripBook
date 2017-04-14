# frozen_string_literal: true
class Book::Reading < ActiveType::Object
  include ParseBoolean

  nests_one :user, scope: proc { User.all }
  nests_one :book, scope: proc { Book.all }
  nests_one :story, scope: proc { BookStory.all }
  attribute :ready_for_release, :boolean

  delegate :content,  :privacy_level,
           :content=, :privacy_level=,
           to: :story, prefix: true

  validates :user, :book, presence: true

  after_initialize :find_story
  before_validation :find_story
  before_save :update_user_book_story
  before_save :mark_book_holding_to_ready_for_realease

  private

  def find_story
    return unless book&.isbn.present?
    self.story ||= user&.book_stories.for_isbn(book.isbn).first_or_create!
  end

  def update_user_book_story
    story.assign_attributes(
      publish: true
    )
    story.save!
  end

  def mark_book_holding_to_ready_for_realease
    return unless parse_boolean(ready_for_release)
    @book_holding = book.holdings.where(user: user).holding.last
    return unless @book_holding.present?
    @book_holding.ready_for_release!
  end
end
