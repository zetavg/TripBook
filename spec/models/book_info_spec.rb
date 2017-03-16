# frozen_string_literal: true
require 'rails_helper'

RSpec.describe BookInfo, type: :model do
  it { is_expected.to have_one(:cover_image) }
  it { is_expected.to have_many(:books) }
  it { is_expected.to have_many(:book_holdings) }
  it { is_expected.to have_many(:book_stories) }
  it { is_expected.to have_many(:book_summaries) }
  it { is_expected.to validate_presence_of(:isbn) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.not_to allow_value('hello').for(:isbn) }
  it { is_expected.not_to allow_value('123456789').for(:isbn) }

  describe "life cycle" do
    describe "create" do
      subject(:book_info) { create(:book_info, isbn: ' 978-3721201451 ') }

      it "strips the ISBN" do
        expect(book_info.isbn).to eq('9783721201451')
      end
    end
  end
end
