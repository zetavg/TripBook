# frozen_string_literal: true
class Me::OwnedBooksController < ApplicationController
  layout 'me/owned_books'

  def index
    @books = books_scope.includes(info: :cover_image)
  end

  def show
    find_book
  end

  def new
    @book = books_scope.build
  end

  def create
    @book = books_scope.build(create_book_params)

    if @book.save
      redirect_to edit_me_owned_book_path(@book), flash: { success: "已新增藏書《#{@book.name}》，繼續填入以下內容吧！" }
    else
      render :new
    end
  end

  def edit
    find_book
    @book.build_story unless @book.story
    @book.story.publish = true
    @book.build_summary unless @book.summary
  end

  def update
    find_book

    if @book.update_attributes(update_book_params)
      redirect_to me_owned_book_path(@book), flash: { success: "已更新藏書《#{@book.name}》。" }
    else
      render :edit
    end
  end

  private

  def books_scope
    current_user.owned_books
  end

  def find_book
    @book = books_scope.find(params[:id]).for(current_user)
  end

  def create_book_params
    return unless params[:book]

    if params.dig(:book, :isbn)
      params.require(:book).permit(:isbn)
    else
      params.require(:book).permit(
        info_attributes: [
          :isbn, :name, :author, :publisher,
          :belonging_cover_image_id
        ]
      )
    end
  end

  def update_book_params
    params.require(:book).permit(
      story_attributes: [
        :id, :content, :publish, :privacy_level
      ],
      summary_attributes: [
        :id, :content, :publish, :privacy_level
      ]
    )
  end
end
