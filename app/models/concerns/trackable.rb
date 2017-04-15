# frozen_string_literal: true
module Trackable
  extend ActiveSupport::Concern

  included do
    has_paper_trail class_name: 'Version', ignore: [:created_at, :updated_at]
  end
end
