# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User::Profile, type: :model do
  it { is_expected.to define_enum_for(:gender) }
end
