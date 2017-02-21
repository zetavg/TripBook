# frozen_string_literal: true
class Me::OwnedBooksController < ApplicationController
  def index
    @books = books_scope.includes(info: :cover_image)
  end

  def show
    @book = books_scope.find(params[:id])
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
    params.require(:book).permit(
      :isbn,
      info_attributes: [
        :isbn, :name, :author, :publisher,
        :belonging_cover_image_id
      ]
    )
  end
end
