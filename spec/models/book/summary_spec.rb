# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Book::Summary, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:book_info) }
  it { is_expected.to belong_to(:book) }
  it { is_expected.to define_enum_for(:privacy_level) }

  describe "#publish" do
    let(:book_summary) { create(:book_summary) }

    it "returns true if published" do
      book_summary.published_at = Time.current
      expect(book_summary.publish).to eq(true)
    end

    it "returns false if published" do
      book_summary.published_at = nil
      expect(book_summary.publish).to eq(false)
    end
  end

  describe "#publish=" do
    let(:book_summary) { create(:book_summary) }

    it "set the book_summary to be published if given truthly values" do
      book_summary.publish = true
      expect(book_summary.publish).to eq(true)
      book_summary.publish = 'true'
      expect(book_summary.publish).to eq(true)
      book_summary.publish = '1'
      expect(book_summary.publish).to eq(true)
    end

    it "set the book_summary to be unpublished if given falsely values" do
      book_summary.publish = false
      expect(book_summary.publish).to eq(false)
      book_summary.publish = 'false'
      expect(book_summary.publish).to eq(false)
      book_summary.publish = '0'
      expect(book_summary.publish).to eq(false)
    end
  end
end
