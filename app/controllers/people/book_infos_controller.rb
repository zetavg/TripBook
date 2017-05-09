# frozen_string_literal: true
class People::BookInfosController < PeopleController
  private

  def book_infos_scope
    BookInfo.all
  end

  def find_book_info
    @book_info = book_infos_scope.find(params[:book_info_id] || params[:id])
  end
end
