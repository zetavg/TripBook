# frozen_string_literal: true
class BookInfosController < ApplicationController
  before_action :authenticate_user!, only: [:show], if: :show_book_info_requires_sign_in

  def index
    @book_infos = book_infos_scope.includes(:cover_image).reorder(updated_at: :desc).page(params[:page]).per(20)
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
    @book_info = book_infos_scope.find(params[:isbn])
  end

  def show_book_info_requires_sign_in
    Config.feature_flags.show_book_info_requires_sign_in
  end
end
