# frozen_string_literal: true
module MethodMissing
  extend ActiveSupport::Concern

  included do
    cattr_accessor :class_respond_to_missing_methods
    cattr_accessor :instance_respond_to_missing_methods
    cattr_accessor :class_method_missing_methods
    cattr_accessor :instance_method_missing_methods
  end

  class_methods do
    def method_missing(method, *args, &block)
      if method =~ /^human\_.+/
        attr_name = method.to_s.gsub(/^human\_/, "")
        attr_values = try(attr_name)

        Hash[attr_values.map do |key, value|
          begin
            [human_enum_name!(attr_name, value), value]
          rescue I18n::MissingTranslationData
            [key, value]
          end
        end]
      else
        super
      end
    end

    def respond_to_missing?(method, *args)
      method.match(/^human\_.+/) || super
    end
  end

  def method_missing(method, *args, &block)
    if method =~ /^human\_.+/
      attr_name = method.to_s.gsub(/^human\_/, "")
      attr_values = try(attr_name)

      Hash[attr_values.map do |key, value|
        begin
          [human_enum_name!(attr_name, value), value]
        rescue I18n::MissingTranslationData
          [key, value]
        end
      end]
    else
      super
    end
  end

  def respond_to_missing?(method, *args)
    method.match(/^human\_.+/) || super
  end
end
