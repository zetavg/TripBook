# frozen_string_literal: true
class BookInfo
  class Search
    def initialize(using: :db)
      case using
      when :db
        @search = DatabaseSearch.new
      else
        throw "Unknown search adoptor: #{using}"
      end
    end

    def with(type, query = nil)
      if query.blank?
        query = type
        type = :query
      else
        type = type.to_sym
      end

      @search.add_query(type, query)

      self
    end

    def results
      @search.results
    end
  end

  class DatabaseSearch
    def initialize
      @scope = BookInfo.all
    end

    def add_query(type, query)
      case type
      when :query
        @scope = @scope.where(
          "isbn ILIKE ? OR isbn_10 ILIKE ? OR isbn_13 ILIKE ? OR name ILIKE ? OR author ILIKE ?",
          "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%"
        )
      else
        throw "Unknown query type: #{type}"
      end
    end

    def results
      @scope.limit(100)
    end
  end
end
