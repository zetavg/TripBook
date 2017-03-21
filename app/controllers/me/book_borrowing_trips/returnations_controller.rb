# frozen_string_literal: true
class Me::BookBorrowingTrips::ReturnationsController < Me::BorrowingTripsController
  def create
    find_book
    find_book_borrowing_trip

    @returnation = Book::BorrowingTrip::Returnation.new(borrowing_trip: @book_borrowing_trip)

    if @returnation.save
      redirect_to me_owned_book_borrowing_trip_path(@book_borrowing_trip, owned_book_id: @book.id),
                  flash: { success: "已結束藏書《#{@book.name}》的旅程" }
    else
      redirect_to me_owned_book_borrowing_trip_path(@book_borrowing_trip, owned_book_id: @book.id),
                  flash: { error: "操作失敗" }
    end
  end
end
