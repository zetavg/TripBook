# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Book::BorrowingTrip, type: :model do
  it { is_expected.to belong_to(:book) }
  it { is_expected.to have_many(:borrowings) }
  it { is_expected.to have_one(:current_borrowing) }

  it "should require unique value for book if active" do
    book = create(:book)
    existing_book_borrowing_trip = create(:book_borrowing_trip, book: book)

    new_book_borrowing_trip = build(:book_borrowing_trip, book: book)
    expect(new_book_borrowing_trip).not_to be_valid

    existing_book_borrowing_trip.end!
    expect(new_book_borrowing_trip).to be_valid
  end

  it "validates if the book is holding by the owner on create" do
    book = create(:book)
    create(:book_holding, book: book)

    book_borrowing_trip = build(:book_borrowing_trip, book: book)
    expect(book_borrowing_trip).not_to be_valid

    create(:book_holding, book: book, user: book.owner)
    book_borrowing_trip.book.reload
    expect(book_borrowing_trip).to be_valid
  end

  describe "life cycle" do
    describe "after create" do
      subject(:book_borrowing_trip) { create(:book_borrowing_trip, book: book) }
      let(:book) { create(:book) }

      it "makes the current holding becomes ready_for_release" do
        expect { subject }.to change { book.reload.current_holding.state }.from('holding').to('ready_for_release')
      end
    end

    describe "book returned to owner" do
      subject { create(:book_holding, user: book.owner, book: book) }
      let!(:book_borrowing_trip) { create(:book_borrowing_trip, book: book) }
      let(:book) { create(:book) }

      it "ends itself" do
        expect { subject }.to change { book_borrowing_trip.reload.state }.from('pending').to('ended')
      end
    end

    describe "should be prepare to end" do
      subject { Timecop.travel book_borrowing_trip.max_durition.from_now }
      let!(:book_borrowing_trip) { create(:book_borrowing_trip) }
      after { Timecop.return }

      context "pending" do
        it "becomes ended" do
          expect { subject }.to change { book_borrowing_trip.reload.state }.from('pending').to('ended')
        end
      end

      context "in_progress" do
        before { create(:book_borrowing, borrowing_trip: book_borrowing_trip) }

        it "becomes prepare_to_end" do
          expect { subject }.to change { book_borrowing_trip.reload.state }.from('in_progress').to('prepare_to_end')
        end
      end
    end

    describe "end" do
      subject { book_borrowing_trip.reload.end! }
      let!(:book_borrowing_trip) { create(:book_borrowing_trip, book: book) }
      let(:book) { create(:book) }

      it "ends all borrowings" do
        book_borrowing = create(:book_borrowing, borrowing_trip: book_borrowing_trip)
        expect do
          create(:book_holding, book: book, user: book.owner)
          book_borrowing_trip.end!
        end.to change { book_borrowing.reload.state }.from('holding').to('released')
        expect(book_borrowing.ended_at).to be_present
      end

      context "pending" do
        it "makes the current holding be holding" do
          expect { subject }.to change { book.reload.current_holding.state }.from('ready_for_release').to('holding')
        end

        it "sets ended_at" do
          expect(book_borrowing_trip.ended_at).to be_blank
          subject
          expect(book_borrowing_trip.ended_at).not_to be_blank
        end
      end

      context "book is not holding by the owner" do
        before { create(:book_borrowing, borrowing_trip: book_borrowing_trip) }

        it "should not happen" do
          expect { subject }.to raise_error(AASM::InvalidTransition)
        end
      end
    end
  end

  describe "#active?" do
    it "returns true if in active state" do
      book_borrowing_trip = create(:book_borrowing_trip)
      expect(book_borrowing_trip.active?).to eq(true)
      book_borrowing_trip.end!
      expect(book_borrowing_trip.active?).to eq(false)
    end
  end

  describe "#end?" do
    it "returns true if in end state" do
      book_borrowing_trip = create(:book_borrowing_trip)
      expect(book_borrowing_trip.end?).to eq(false)
      book_borrowing_trip.end!
      expect(book_borrowing_trip.end?).to eq(true)
    end
  end

  describe "#max_single_durition" do
    it "returns a ActiveSupport::Duration" do
      subject.max_single_durition_days = 1
      expect(subject.max_single_durition).to be_a(ActiveSupport::Duration)
    end
  end

  describe "#max_single_durition=" do
    it "sets the max_single_durition_days by period" do
      subject.max_single_durition = 3.days
      expect(subject.max_single_durition_days).to eq(3)
    end

    it "sets the max_single_durition_days by number" do
      subject.max_single_durition = 3
      expect(subject.max_single_durition_days).to eq(3)
    end
  end

  describe "#max_durition" do
    it "returns a ActiveSupport::Duration" do
      subject.max_durition_days = 1
      expect(subject.max_durition).to be_a(ActiveSupport::Duration)
    end
  end

  describe "#max_durition=" do
    it "sets the max_durition_days by period" do
      subject.max_durition = 3.days
      expect(subject.max_durition_days).to eq(3)
    end

    it "sets the max_durition_days by number" do
      subject.max_durition = 3
      expect(subject.max_durition_days).to eq(3)
    end
  end

  describe "#durition" do
    it "returns a ActiveSupport::Duration" do
      book_borrowing_trip = create(:book_borrowing_trip)
      Timecop.freeze 1_234_567.seconds.since(book_borrowing_trip.created_at)
      expect(book_borrowing_trip.durition).to be_a(ActiveSupport::Duration)
      expect(book_borrowing_trip.durition).to eq(1_234_567.seconds)
      book_borrowing_trip.end!
      Timecop.freeze 2_345_678.seconds.since(book_borrowing_trip.created_at)
      expect(book_borrowing_trip.durition).to eq(1_234_567.seconds)
      Timecop.return
    end
  end

  describe "#next_step" do
    it "returns a Symbol" do
      book_borrowing_trip = create(:book_borrowing_trip)
      expect(book_borrowing_trip.next_step).to be_a(Symbol)
    end
  end
end
