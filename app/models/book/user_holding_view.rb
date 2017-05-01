# frozen_string_literal: true
class Book::UserHoldingView < Book
  self.table_name = 'user_holding_books'
  include UserHoldingViewBorrowingRelations

  belongs_to :user
  belongs_to :holding
end
