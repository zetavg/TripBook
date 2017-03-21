# frozen_string_literal: true
class BookInfos::BorrowDemands::CancellationsController < ApplicationController
  def create
    find_book_borrow_demand
    @cancellation = Book::BorrowDemand::Cancellation.new(borrow_demand: @book_borrow_demand)

    if @cancellation.save
      redirect_to :back, flash: { success: '已取消登記' }
    else
      redirect_to :back, flash: { error: '操作失敗' }
    end
  end

  private

  def find_book_borrow_demand
    @book_borrow_demand = current_user.book_borrow_demands.active.find_by(book_isbn: params[:book_info_isbn])
  end
end
