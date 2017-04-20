# frozen_string_literal: true
class Me::Books::ReadingsController < Me::BooksController
  layout 'me/books'

  def new
    find_book
    build_reading
  end

  def create
    find_book
    build_reading

    @reading.assign_attributes(reading_params)
    if @reading.save
      redirect_to me_books_path, flash: { success: '已更新' }
    else
      render :new
    end
  end

  private

  def build_reading
    @reading = Book::Reading.new(book: @book, user: current_user)
  end

  def reading_params
    params.require(:book_reading).permit(:story_content, :story_privacy_level, :ready_for_release)
  end
end
