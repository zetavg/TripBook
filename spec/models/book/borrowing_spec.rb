# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Book::Borrowing, type: :model do
  it { is_expected.to belong_to(:borrowing_trip) }
  it { is_expected.to belong_to(:holding) }

  describe "life cycle" do
    describe "after create" do
      subject(:book_borrowing) do
        create(:book_borrowing, borrowing_trip: book_borrowing_trip.reload, borrower: borrower, id: borrowing_uuid)
      end
      let(:borrowing_uuid) { SecureRandom.uuid }
      let(:book_borrowing_trip) { create(:book_borrowing_trip, holding: book.current_holding) }
      let(:book) { create(:book) }
      let(:borrower) { create(:user) }

      it "makes the book_borrowing_trip to be in_progress" do
        expect { subject }.to change { book_borrowing_trip.reload.state }.from('pending').to('in_progress')
      end

      it "increases borrowings_count of the book_borrowing_trip" do
        expect { subject }.to change { book_borrowing_trip.reload.borrowings_count }.from(0).to(1)
      end

      it "makes the holder of the book becomes the borrower" do
        expect { subject }.to change { book.reload.holder }.to(borrower)
      end

      it "makes the previous holding to be released" do
        origional_holding = book.current_holding
        expect { subject }.to change { origional_holding.reload.state }.to('released')
      end

      context "has previous borrowing" do
        let!(:previous_borrowing) { create(:book_borrowing, borrowing_trip: book_borrowing_trip) }

        it "makes the previous borrowing to end" do
          expect { subject }.to change { previous_borrowing.reload.state }.from('holding').to('released')
          expect(previous_borrowing.ended_at).to be_present
        end
      end

      context "has borrow demand" do
        let!(:borrow_demand) { create(:book_borrow_demand, user: borrower, book_isbn: book.isbn) }

        it "marks the borrow demand as fulfilled" do
          expect { subject }.to change { borrow_demand.reload.state }.from('pending').to('fulfilled')
        end
      end

      context "has avaliable borrowing invitation" do
        let!(:borrowing_invitation) do
          create(:book_borrowing_invitation, holding: book_borrowing_trip.book.current_holding)
        end

        it "logs its id on the borrowing invitation" do
          expect { subject }.to change { borrowing_invitation.reload.borrowing_id }.from(nil).to(borrowing_uuid)
        end
      end
    end
  end

  describe "#previous_borrowing" do
    let(:book_borrowing_trip) { create(:book_borrowing_trip) }

    it "returns the previous borrowing" do
      b1 = create(:book_borrowing, borrowing_trip: book_borrowing_trip.reload)
      expect(b1.previous_borrowing).to eq(nil)
      b2 = create(:book_borrowing, borrowing_trip: book_borrowing_trip.reload)
      expect(b2.previous_borrowing).to eq(b1)
      b3 = create(:book_borrowing, borrowing_trip: book_borrowing_trip.reload)
      expect(b3.previous_borrowing).to eq(b2)
    end
  end

  describe "#ready_for_release!" do
    it "works" do
      book_borrowing = create(:book_borrowing)
      expect { book_borrowing.ready_for_release! }.to change { book_borrowing.state }.to('ready_for_release')
    end
  end

  describe "#cancel_release!" do
    it "works" do
      book_borrowing = create(:book_borrowing)
      book_borrowing.ready_for_release!
      expect { book_borrowing.cancel_release! }.to change { book_borrowing.state }.to('holding')
    end
  end
end
