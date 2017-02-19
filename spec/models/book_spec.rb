# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Book, type: :model do
  it { is_expected.to belong_to(:info) }
  it { is_expected.to belong_to(:owner) }
  it { is_expected.to have_many(:holdings) }
  it { is_expected.to have_many(:past_holders) }
  it { is_expected.to have_one(:current_holding) }
  it { is_expected.to have_one(:holder) }

  describe "life cycle" do
    describe "create" do
      subject(:book) { create(:book) }

      it "creates the initial holding record" do
        initial_holding_record = book.holdings.last
        expect(initial_holding_record.user).to eq(book.owner)
      end
    end
  end
end
