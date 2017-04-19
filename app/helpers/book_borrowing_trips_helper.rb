# frozen_string_literal: true
module BookBorrowingTripsHelper
  def book_borrowing_trip_brief_info(book_borrowing_trip)
    info_sentences = []

    if book_borrowing_trip.max_borrowings_count && (book_borrowing_trip.pending? || book_borrowing_trip.in_progress?)
      info_sentences << "最多借給 #{book_borrowing_trip.max_borrowings_count} 人"
    end

    if book_borrowing_trip.borrowings_count > 1
      info_sentences << "已借給 #{book_borrowing_trip.borrowings_count} 人"
    end

    if book_borrowing_trip.active?
      current_durition = Time.current - book_borrowing_trip.created_at

      info_sentences << "經過了 #{distance_of_time_in_words(current_durition)}"

      if book_borrowing_trip.max_durition && (book_borrowing_trip.pending? || book_borrowing_trip.in_progress?)
        remining_time = book_borrowing_trip.max_durition - current_durition
        info_sentences << "剩下 #{distance_of_time_in_words(remining_time)}"
      end
    end

    info_sentences.join('，')
  end
end
