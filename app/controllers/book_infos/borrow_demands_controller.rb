# frozen_string_literal: true
class BookInfos::BorrowDemandsController < ApplicationController
  def create
    @book_borrow_demand = current_user.book_borrow_demands.build(book_isbn: params[:book_info_isbn])

    if @book_borrow_demand.save
      redirect_to :back, flash: { success: '已登記' }
    else
      redirect_to :back, flash: { error: '操作失敗' }
    end
  end
end
