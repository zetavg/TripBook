# frozen_string_literal: true
class Admin < ApplicationRecord
  include Trackable
  devise :database_authenticatable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable
end
