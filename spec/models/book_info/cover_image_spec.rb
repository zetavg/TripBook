# frozen_string_literal: true
require 'rails_helper'

RSpec.describe BookInfo::CoverImage, type: :model do
  it { is_expected.to belong_to(:book_info) }
end
