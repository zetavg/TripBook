# frozen_string_literal: true
class BooksController < ApplicationController
  def index
    @book_infos = book_infos_scope.page(params[:page])
  end

  def show
    find_book_info
  end

  private

  def book_infos_scope
    BookInfo.all
  end

  def find_book_info
    @book_info = book_infos_scope.find(params[:id])
  end
end
