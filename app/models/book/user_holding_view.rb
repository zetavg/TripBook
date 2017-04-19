# frozen_string_literal: true
class Book::UserHoldingView < Book
  self.table_name = 'user_holding_books'

  belongs_to :user
  belongs_to :holding
end
