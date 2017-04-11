# frozen_string_literal: true
class Me::Books::ReadingCompletionsController < Me::BooksController
  def new
    find_book
    build_reading_completion
  end

  def create
    find_book
    build_reading_completion

    @reading_completion.assign_attributes(reading_completion_params)
    if @reading_completion.save
      redirect_to me_books_path(show: 'ready_for_release'), flash: { success: '已更新' }
    else
      render :new
    end
  end

  private

  def build_reading_completion
    @reading_completion = Book::ReadingCompletion.new(book: @book, user: current_user)
  end

  def reading_completion_params
    params.require(:book_reading_completion).permit(:story_content, :story_privacy_level)
  end
end
