# frozen_string_literal: true
class BooksController < ApplicationController
  def index
    @book_infos = book_infos_scope.page(params[:page])
  end

  def show
    find_book_info
    @book_holding_stories = Book::Story::HoldingView
                            .for_isbn(@book_info.isbn)
                            .where(holding_state: 'ready_for_release')
                            .published
                            .open_to_world
                            .includes(:user)
  end

  private

  def book_infos_scope
    BookInfo.all
  end

  def find_book_info
    @book_info = book_infos_scope.find(params[:id])
  end
end
