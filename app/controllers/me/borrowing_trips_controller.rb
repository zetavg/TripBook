# frozen_string_literal: true
class Me::BorrowingTripsController < ApplicationController
  def index
    find_book
  end

  def show
    find_book
    find_book_borrowing_trip
  end

  def new
    find_book
    @book_borrowing_trip = book_borrowing_trip_scope.build
  end

  def create
    find_book
    @book_borrowing_trip = book_borrowing_trip_scope.build(book_borrowing_trip_params)

    if @book_borrowing_trip.save
      redirect_to me_owned_book_path(@book), flash: { success: "已為藏書《#{@book.name}》預備新的旅程" }
    else
      render :new
    end
  end

  def edit
    find_book
    find_book_borrowing_trip
  end

  def update
    find_book
    find_book_borrowing_trip

    if @book_borrowing_trip.end?
      redirect_to me_owned_book_borrowing_trip_path(@book_borrowing_trip, owned_book_id: @book.id),
                  flash: { success: "無法編輯已結束的旅程" }
      return
    end

    if @book_borrowing_trip.update_attributes(book_borrowing_trip_params)
      redirect_to me_owned_book_borrowing_trip_path(@book_borrowing_trip, owned_book_id: @book.id),
                  flash: { success: "已更新藏書《#{@book.name}》的旅程" }
    else
      render :new
    end
  end

  private

  def books_scope
    current_user.owned_books
  end

  def find_book
    @book = books_scope.find(params[:owned_book_id]).for(current_user)
  end

  def book_borrowing_trip_scope
    Book::BorrowingTrip.where(book: @book || find_book)
  end

  def find_book_borrowing_trip
    @book_borrowing_trip = book_borrowing_trip_scope.find(params[:id] || params[:borrowing_trip_id])
  end

  def book_borrowing_trip_params
    params.require(:book_borrowing_trip).permit(
      :max_durition_days,
      :max_single_durition_days,
      :max_borrowings_count
    )
  end
end
