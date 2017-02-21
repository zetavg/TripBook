# frozen_string_literal: true
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def method_missing(method, *args)
    belonging_method_match = method.match(/^belonging_(.+)_id(=?)$/)

    if belonging_method_match
      attribute_name = belonging_method_match[1]
      case belonging_method_match[2]
      when '='
        attribute_class = (try(attribute_name) || try("build_#{attribute_name}")).class
        try("#{attribute_name}=", args[0] && attribute_class.find(args[0]))
      else
        try(attribute_name)&.id
      end
    else
      super
    end
  end

  def respond_to_missing?(method, *args)
    method.match(/^belonging_(.+)_id(=?)$/) || super
  end
end
