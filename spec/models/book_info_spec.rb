# frozen_string_literal: true
require 'rails_helper'

RSpec.describe BookInfo, type: :model do
  it { is_expected.to have_one(:cover_image) }
  it { is_expected.to have_many(:books) }
  it { is_expected.to validate_presence_of(:isbn) }
  it { is_expected.to validate_presence_of(:name) }
end
