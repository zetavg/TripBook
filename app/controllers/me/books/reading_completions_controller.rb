# frozen_string_literal: true
class Me::Books::ReadingCompletionsController < Me::BooksController
  def create
    find_book
    @borrowing = @book.current_borrowing_trip.borrowings.active.for_user(current_user).last
    @reading_completion = Book::Borrowing::ReadingCompletion.new(borrowing: @borrowing)
    @reading_completion.save!
    redirect_to me_books_path(show: 'ready_for_release'), flash: { success: '已更新' }
  end
end
