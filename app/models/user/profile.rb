# frozen_string_literal: true
class User
  class Profile < ApplicationRecord
    belongs_to :user, optional: true

    enum gender: {
      male:   1,
      female: 2,
      other:  3
    }
  end
end
