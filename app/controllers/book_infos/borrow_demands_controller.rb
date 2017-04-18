# frozen_string_literal: true
class BookInfos::BorrowDemandsController < ApplicationController
  def create
    @borrow_demand = borrow_demand_scope.build(borrow_demand_params)

    if @borrow_demand.save
      redirect_back fallback_location: @borrow_demand.book_info || book_infos_path, flash: { success: '已登記' }
    else
      redirect_back fallback_location: @borrow_demand.book_info || book_infos_path, flash: { error: '操作失敗' }
    end
  end

  private

  def borrow_demand_scope
    current_user.book_borrow_demands.where(book_isbn: params[:book_info_isbn])
  end

  def find_borrow_demand
    @borrow_demand = borrow_demand_scope.active.last
  end

  def borrow_demand_params
    params.fetch(:book_borrow_demand, {}).permit(:message)
  end
end
