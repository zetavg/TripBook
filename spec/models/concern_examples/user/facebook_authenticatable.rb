# frozen_string_literal: true
require 'rails_helper'

RSpec.shared_examples "User::FacebookAuthenticatable" do
  describe "#from_facebook" do
    subject do
      described_class.from_facebook(parameters)
    end
    let(:parameters) do
      facebook_parameters.merge(find_possible_user: false)
    end
    let(:facebook_parameters) do
      {
        access_token: facebook_account_attributes[:access_token],
        access_token_expires_at: facebook_account_attributes[:access_token_expires_at],
        id: facebook_account_attributes[:facebook_id],
        email: facebook_account_attributes[:email],
        name: facebook_account_attributes[:name],
        gender: %w(male female hello).sample,
        picture_url: facebook_account_attributes[:picture_url],
        cover_photo_url: facebook_account_attributes[:cover_photo_url]
      }
    end
    let(:facebook_account_attributes) do
      attributes_for(:user_facebook_account)
    end

    context "a corresponding User::FacebookAccount does not exists" do
      it "creates a new User::FacebookAccount" do
        expect { subject }.to change { User::FacebookAccount.count }.from(0).to(1)
      end

      it "creates a new User that is from_facebook and new_from_facebook" do
        new_user = subject
        expect(new_user).to be_persisted
        expect(new_user).to be_from_facebook
        expect(new_user).to be_new_from_facebook
      end

      it "saves data for the new user" do
        new_user = subject
        expect(new_user.name).to eq(facebook_account_attributes[:name])

        if %w(male female).include?(parameters[:gender])
          expect(new_user.gender).to eq(parameters[:gender])
        else
          expect(new_user.gender).to eq('other')
        end
      end

      context "facebook_account with with picture and cover_photo" do
        let(:facebook_account_attributes) do
          attributes_for(:user_facebook_account, :with_picture, :with_cover_photo)
        end

        xit "saves the picture and cover_photo for the new user" do
          new_user = subject
          expect(new_user.picture).to be_persisted
          expect(new_user.picture.provider).to eq('facebook')
          expect(new_user.cover_photo).to be_persisted
          expect(new_user.cover_photo.provider).to eq('facebook')
        end
      end
    end

    context "a corresponding User::FacebookAccount exists" do
      before { user_facebook_account }

      context "the User::FacebookAccount have an user" do
        let(:user) { create(:user) }
        let(:user_facebook_account) { create(:user_facebook_account, facebook_account_attributes.merge(user: user)) }

        it "returns the user that is from_facebook but not new_from_facebook" do
          returned_user = subject
          expect(returned_user).to eq(user)
          expect(returned_user).to be_from_facebook
          expect(returned_user).not_to be_new_from_facebook
        end
      end

      context "the User::FacebookAccount does not have an user" do
        let(:user_facebook_account) { create(:user_facebook_account, facebook_account_attributes.merge(user: nil)) }

        it "creates a new user with the facebook_account" do
          new_user = subject
          expect(new_user).to be_persisted
          expect(new_user.facebook_account).to eq(user_facebook_account)
          expect(new_user).to be_from_facebook
          expect(new_user).to be_new_from_facebook
        end
      end
    end

    context "a user with the same email exists" do
      before { user }
      let(:user) { create(:user, email: facebook_account_attributes[:email]) }

      context "with find_possible_user set to false" do
        let(:parameters) do
          facebook_parameters.merge(find_possible_user: false)
        end

        it "raise an error" do
          expect { subject }.to raise_error(StandardError)
        end
      end

      context "with find_possible_user set to true" do
        let(:parameters) do
          facebook_parameters.merge(find_possible_user: true)
        end

        it "returns the user as unauthenticated_from_facebook" do
          returned_user = subject
          expect(returned_user).to eq(user)
          expect(returned_user).to be_unauthenticated_from_facebook
        end
      end
    end
  end
end
