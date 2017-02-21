class Me::BooksController < ApplicationController
  def index
    @show = params[:show] || 'in_hand'
    @books = books_scope(@show)
  end

  private

  def books_scope(show = nil)
    case show
    when 'in_hand'
      current_user.holding_books
    else
      current_user.past_holded_books
    end
  end
end
