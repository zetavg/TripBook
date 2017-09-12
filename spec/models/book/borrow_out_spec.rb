# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Book::BorrowOut, type: :model do
  let(:user) { create(:user) }
  let(:book) { create(:book) }
  let(:instance) do
    Book::BorrowOut.new(
      book: book,
      invitation_users_attributes: [{ user: user, message: 'Hello world!' }]
    )
  end

  describe "instance" do
    subject { instance }

    context "borrowing_trip already exists" do
      let!(:existing_borrowing_trip) do
        create(
          :book_borrowing_trip,
          holding: book.current_holding,
          max_single_durition_days: 30,
          max_durition_days: 365,
          max_borrowings_count: 12
        )
      end

      it "initialize attributes from the existing borrowing_trip" do
        expect(subject.trip_max_single_durition_days).to eq(30)
        expect(subject.trip_max_durition_days).to eq(365)
        expect(subject.trip_max_borrowings_count).to eq(12)
      end
    end
  end

  describe "#save" do
    let(:instance) do
      Book::BorrowOut.new(
        book: book,
        invitation_users_attributes: [{ user: user, message: 'Hello world!' }],
        trip_max_single_durition_days: 38,
        trip_max_durition_days: 1337,
        trip_max_borrowings_count: 228
      )
    end
    subject(:save) { instance.save }

    it { is_expected.to be(true) }

    it "creats a borrowing_trip with specified attributes" do
      expect { subject }.to change { book.reload.borrowing_trips.count }.from(0).to(1)

      borrowing_trip = book.borrowing_trips.last
      expect(borrowing_trip.max_single_durition_days).to eq(38)
      expect(borrowing_trip.max_durition_days).to eq(1337)
      expect(borrowing_trip.max_borrowings_count).to eq(228)
    end

    it "creates invitation_users" do
      expect { subject }.to change {
        book.reload.current_holding.borrowing_invitation&.invitation_users&.count
      }.from(nil).to(1)

      invitation_user = book.current_holding.borrowing_invitation.invitation_users.last
      expect(invitation_user.user).to eq(user)
      expect(invitation_user.message).to eq('Hello world!')
    end

    context "borrowing_trip already exists" do
      let!(:existing_borrowing_trip) do
        create(
          :book_borrowing_trip,
          holding: book.current_holding,
          max_single_durition_days: 30,
          max_durition_days: 365,
          max_borrowings_count: 12
        )
      end

      it { is_expected.to be(true) }

      it "updates max_single_durition_days of the existing borrowing_trips" do
        expect { subject }.to change { existing_borrowing_trip.reload.max_single_durition_days }.from(30).to(38)
      end

      it "updates max_durition_days of the existing borrowing_trips" do
        expect { subject }.to change { existing_borrowing_trip.reload.max_durition_days }.from(365).to(1337)
      end

      it "updates max_borrowings_count of the existing borrowing_trips" do
        expect { subject }.to change { existing_borrowing_trip.reload.max_borrowings_count }.from(12).to(228)
      end

      it "creates invitation_users" do
        expect { subject }.to change {
          book.reload.current_holding.borrowing_invitation&.invitation_users&.count
        }.from(nil).to(1)

        invitation_user = book.current_holding.borrowing_invitation.invitation_users.last
        expect(invitation_user.user).to eq(user)
        expect(invitation_user.message).to eq('Hello world!')
      end
    end

    context "borrowing_trip and borrowing_invitation already exists" do
      let!(:existing_borrowing_trip) do
        create(
          :book_borrowing_trip,
          holding: book.reload.current_holding,
          max_single_durition_days: 30,
          max_durition_days: 365,
          max_borrowings_count: 12
        )
      end

      let!(:existing_borrowing_invitation) do
        create(
          :book_borrowing_invitation,
          holding: book.reload.current_holding
        )
      end

      let!(:existing_invitation_user_user) do
        create(:user)
      end

      let!(:existing_invitation_user) do
        create(
          :book_borrowing_invitation_invitation_user,
          borrowing_invitation: existing_borrowing_invitation,
          user: existing_invitation_user_user,
          message: 'Hello.'
        )
      end

      it { is_expected.to be(true) }

      it "creates new invitation_users" do
        expect { subject }.to change {
          book.reload.current_holding.borrowing_invitation&.invitation_users&.count
        }.from(1).to(2)

        invitation_user = book.current_holding.borrowing_invitation.invitation_users.last
        expect(invitation_user.user).to eq(user)
        expect(invitation_user.message).to eq('Hello world!')
      end
    end

    context "book is not holding by the owner" do
      before do
        book.holdings.create!(user: user)
      end

      it { is_expected.to be(false) }
    end
  end
end
