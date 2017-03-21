# frozen_string_literal: true
class Book::Story::HoldingView < Book::Story
  self.table_name = 'book_holding_stories'

  belongs_to :holding, class_name: 'Book::Holding'
  belongs_to :previous_holding, class_name: 'Book::Holding'
  belongs_to :book
  belongs_to :book_owner, class_name: 'User'
end
