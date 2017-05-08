# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Book::BorrowDemand::WithDemandUser, type: :model do
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:book_info) }
  it { is_expected.to validate_presence_of(:demand_user) }

  it { is_expected.to validate_presence_of(:borrow_demand) }
  it { is_expected.to validate_presence_of(:borrow_demand_demand_user) }

  describe "life cycle" do
    let(:model) do
      Book::BorrowDemand::WithDemandUser.new(
        user_id: user.id,
        demand_user_id: demand_user.id,
        book_isbn: book_info.isbn
      )
    end
    let(:user) { create(:user) }
    let(:demand_user) { create(:user) }
    let(:book_info) { create(:book_info) }

    describe "initialize" do
      context "Book::BorrowDemand already exists" do
        before { create(:book_borrow_demand, user: user, book_isbn: book_info.isbn, message: 'hello') }

        it "preloads the message" do
          expect(model.message).to eq('hello')
        end
      end

      context "Book::BorrowDemand and Book::BorrowDemand::DemandUser already exists" do
        let(:borrow_demand) { create(:book_borrow_demand, user: user, book_isbn: book_info.isbn) }
        before do
          create(:book_borrow_demand_demand_user, borrow_demand: borrow_demand, user: demand_user, message: 'hello')
        end

        it "preloads the demand_user_message" do
          expect(model.demand_user_message).to eq('hello')
        end
      end
    end

    describe "save" do
      subject { model.save! }
      let(:model) do
        Book::BorrowDemand::WithDemandUser.new(
          user_id: user.id,
          demand_user_id: demand_user.id,
          book_isbn: book_info.isbn,
          message: 'hi',
          demand_user_message: 'hello'
        )
      end

      it "creates a Book::BorrowDemand" do
        expect { subject }.to change {
          user.reload.book_borrow_demands.find_by(book_isbn: book_info.isbn)&.message
        }.from(nil).to('hi')
      end

      it "creates a Book::BorrowDemand::DemandUser" do
        expect { subject }.to change {
          user.reload.book_borrow_demands.find_by(book_isbn: book_info.isbn)&.demand_users&.last&.message
        }.from(nil).to('hello')
      end

      context "Book::BorrowDemand already exists" do
        let!(:borrow_demand) { create(:book_borrow_demand, user: user, book_isbn: book_info.isbn, message: 'yo') }

        it "updates the message of Book::BorrowDemand" do
          expect { subject }.to change { borrow_demand.reload.message }.from('yo').to('hi')
        end
      end

      context "Book::BorrowDemand and Book::BorrowDemand::DemandUser already exists" do
        let(:borrow_demand) { create(:book_borrow_demand, user: user, book_isbn: book_info.isbn) }
        let(:borrow_demand_demand_user) do
          create(:book_borrow_demand_demand_user, borrow_demand: borrow_demand, user: demand_user, message: 'yo')
        end

        it "updates the message of Book::BorrowDemand::DemandUser" do
          expect { subject }.to change { borrow_demand_demand_user.reload.message }.from('yo').to('hello')
        end
      end
    end
  end
end
