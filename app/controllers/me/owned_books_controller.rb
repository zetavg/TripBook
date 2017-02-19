# frozen_string_literal: true
class Me::OwnedBooksController < ApplicationController
  def index
    @books = books_scope
  end

  def show
    @books = books_scope.find(params[:id])
  end

  def new
    @book = books_scope.build
  end

  def create
    @book = books_scope.build(book_params)

    if @book.save
      redirect_to me_owned_books_path, flash: { success: "已新增藏書《#{@book.name}》。" }
    else
      render :new
    end
  end

  private

  def books_scope
    current_user.owned_books
  end

  def book_params
    params.require(:book).permit(:isbn)
  end
end
