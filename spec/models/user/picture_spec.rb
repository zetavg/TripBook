# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User::Picture, type: :model do
  it { is_expected.to validate_uniqueness_of(:secure_token) }
end
