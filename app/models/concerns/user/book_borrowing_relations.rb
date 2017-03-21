# frozen_string_literal: true
class User
  module BookBorrowingRelations
    extend ActiveSupport::Concern

    included do
      has_many :book_borrow_demands, class_name: 'Book::BorrowDemand'
      # TODO: add more
    end
  end
end
