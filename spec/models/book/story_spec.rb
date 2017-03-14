# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Book::Story, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:book_info) }
  it { is_expected.to belong_to(:book) }
  it { is_expected.to define_enum_for(:privacy_level) }

  describe "#publish" do
    let(:book_story) { create(:book_story) }

    it "returns true if published" do
      book_story.published_at = Time.current
      expect(book_story.publish).to eq(true)
    end

    it "returns false if published" do
      book_story.published_at = nil
      expect(book_story.publish).to eq(false)
    end
  end

  describe "#publish=" do
    let(:book_story) { create(:book_story) }

    it "set the book_story to be published if given truthly values" do
      book_story.publish = true
      expect(book_story.publish).to eq(true)
      book_story.publish = 'true'
      expect(book_story.publish).to eq(true)
      book_story.publish = '1'
      expect(book_story.publish).to eq(true)
    end

    it "set the book_story to be unpublished if given falsely values" do
      book_story.publish = false
      expect(book_story.publish).to eq(false)
      book_story.publish = 'false'
      expect(book_story.publish).to eq(false)
      book_story.publish = '0'
      expect(book_story.publish).to eq(false)
    end
  end
end
