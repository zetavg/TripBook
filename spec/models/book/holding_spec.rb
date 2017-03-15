# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Book::Holding, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:book) }
  it { is_expected.to belong_to(:previous_holding) }

  it { is_expected.to have_immutable_attribute(:user_id) }
  it { is_expected.to have_immutable_attribute(:book_id) }

  describe "life cycle" do
    describe "create" do
      let(:book) { create(:book) }
      subject { create(:book_holding, book: book) }

      it "sets the old active holding to released" do
        last_holding = book.current_holding
        expect { subject }.to change { last_holding.reload.state }.from('holding').to('released')
      end
    end

    describe "destroy" do
      subject { book_holding.destroy }
      let(:book) { create(:book) }
      let(:book_holding) { create(:book_holding, book: book) }

      context "state is holding with other holding record" do
        let(:last_book_holding) do
          create(:book_holding, book: book)
        end

        it "sets the last holding record of the book to state holding" do
          last_book_holding
          book_holding
          expect { subject }.to change { last_book_holding.reload.state }.from('released').to('holding')
        end
      end
    end
  end
end
