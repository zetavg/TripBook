# frozen_string_literal: true
class Book
  module UserHoldingViewBorrowingRelations
    extend ActiveSupport::Concern

    included do
      has_one :borrowing, primary_key: :holding_id, foreign_key: :holding_id
    end
  end
end
