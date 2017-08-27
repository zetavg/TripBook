# frozen_string_literal: true
class People::BookInfos::BorrowDemandsController < People::BookInfosController
  layout :resolve_layout

  def new
    build_borrow_demand
  end

  def create
    build_borrow_demand
    @borrow_demand.assign_attributes(borrow_demand_params)
    @borrow_demand.save!
    redirect_back fallback_location: @book_info, flash: { success: '請求已送出' }
  end

  private

  def build_borrow_demand
    find_person
    find_book_info
    @borrow_demand = Book::BorrowDemand::WithDemandUser.new(
      user: current_user,
      book_info: @book_info,
      demand_user: @person
    )
  end

  def borrow_demand_params
    params.require(:book_borrow_demand_with_demand_user).permit(:message, :demand_user_message)
  end

  def resolve_layout
    return 'people/book_infos/borrow_demands' unless params[:layout].present?
    false
  end
end
