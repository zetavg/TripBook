# frozen_string_literal: true
class BookInfos::BorrowDemands::CancellationsController < BookInfos::BorrowDemandsController
  def create
    find_borrow_demand
    @cancellation = Book::BorrowDemand::Cancellation.new(borrow_demand: @borrow_demand)

    if @cancellation.save
      redirect_back fallback_location: @borrow_demand.book_info || book_infos_path, flash: { success: '已取消登記' }
    else
      redirect_back fallback_location: @borrow_demand.book_info || book_infos_path, flash: { error: '操作失敗' }
    end
  end
end
