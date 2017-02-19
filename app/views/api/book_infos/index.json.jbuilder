# frozen_string_literal: true
json.array! @book_infos, partial: 'api/book_infos/book_info', as: :book_info
