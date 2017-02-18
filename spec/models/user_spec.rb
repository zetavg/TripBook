# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  it_should_behave_like("User::FacebookAuthenticatable")

  it { is_expected.to have_one(:facebook_account) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:name) }
end
