# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Book, type: :model do
  it { is_expected.to belong_to(:info) }
  it { is_expected.to belong_to(:owner) }
  it { is_expected.to have_many(:holdings) }
  it { is_expected.to have_many(:past_holders) }
  it { is_expected.to have_one(:current_holding) }
  it { is_expected.to have_one(:holder) }

  it { is_expected.to have_many(:stories) }
  it { is_expected.to have_many(:summaries) }
  it { is_expected.to have_one(:story) }
  it { is_expected.to have_one(:summary) }

  describe "life cycle" do
    describe "create" do
      subject(:book) { create(:book) }

      it "creates the initial holding record" do
        initial_holding_record = book.holdings.last
        expect(initial_holding_record.user).to eq(book.owner)
      end
    end
  end

  describe "#story" do
    let!(:book_owner) { create(:user) }
    let!(:book) { create(:book, owner: book_owner) }
    let!(:book_owner_book_story) { create(:book_story, user: book_owner, book_isbn: book.isbn) }
    let!(:user_1) { create(:user) }
    let!(:user_1_book_story) { create(:book_story, user: user_1, book_isbn: book.isbn) }
    let!(:user_2) { create(:user) }
    let!(:user_2_book_story) { create(:book_story, user: user_2, book_isbn: book.isbn) }

    it "returns the book story of the currently book holding user" do
      expect(book.story).to eq(book_owner_book_story)
      user_1.book_holdings.create(book: book)
      book.reload
      expect(book.story).to eq(user_1_book_story)
      user_2.book_holdings.create(book: book)
      book.reload
      expect(book.story).to eq(user_2_book_story)
    end

    context "for a specific user" do
      it "returns the book story of the user" do
        expect(book.story).to eq(book_owner_book_story)
        user_1.book_holdings.create(book: book)
        book.reload
        expect(book.story).to eq(user_1_book_story)
        user_2.book_holdings.create(book: book)
        book.for(user_1).reload
        expect(book.story).to eq(user_1_book_story)
      end
    end
  end

  describe "#summary" do
    let!(:book_owner) { create(:user) }
    let!(:book) { create(:book, owner: book_owner) }
    let!(:book_owner_book_summary) { create(:book_summary, user: book_owner, book_isbn: book.isbn) }
    let!(:user_1) { create(:user) }
    let!(:user_1_book_summary) { create(:book_summary, user: user_1, book_isbn: book.isbn) }
    let!(:user_2) { create(:user) }
    let!(:user_2_book_summary) { create(:book_summary, user: user_2, book_isbn: book.isbn) }

    it "returns the book summary of the currently book holding user" do
      expect(book.summary).to eq(book_owner_book_summary)
      user_1.book_holdings.create(book: book)
      book.reload
      expect(book.summary).to eq(user_1_book_summary)
      user_2.book_holdings.create(book: book)
      book.reload
      expect(book.summary).to eq(user_2_book_summary)
    end

    context "for a specific user" do
      it "returns the book summary of the user" do
        expect(book.summary).to eq(book_owner_book_summary)
        user_1.book_holdings.create(book: book)
        book.reload
        expect(book.summary).to eq(user_1_book_summary)
        user_2.book_holdings.create(book: book)
        book.for(user_1).reload
        expect(book.summary).to eq(user_1_book_summary)
      end
    end
  end
end
