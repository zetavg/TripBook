# frozen_string_literal: true
class API::BookInfosController < API::APIController
  def index
    @search = BookInfo::Search.new
    @search.with(params[:query]) if params[:query].present?
    @book_infos = @search.results
  end
end
