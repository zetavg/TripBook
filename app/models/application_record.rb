# frozen_string_literal: true
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include ParseBoolean

  default_scope -> { order(created_at: :asc) }

  class << self
    def human_enum_name(enum_name, enum_value)
      return unless enum_value
      I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
    end

    def human_enum_name!(enum_name, enum_value)
      return unless enum_value
      I18n.t!("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
    end

    private

    def method_missing(method, *args, &block)
      human_attrs_method_match = method.match(/^human_(.+)$/)

      if human_attrs_method_match
        attr_name = human_attrs_method_match[1]
        attr_values = try(attr_name)

        Hash[attr_values.map do |key, _value|
          begin
            [human_enum_name!(attr_name, key), key]
          rescue I18n::MissingTranslationData
            [key, key]
          end
        end]
      else
        super
      end
    end

    def respond_to_missing?(method, *args)
      method.match(/^human_(.+)$/) || super
    end
  end

  def method_missing(method, *args)
    belonging_method_match = method.match(/^belonging_(.+)_id(=?)$/)
    human_attr_method_match = method.match(/^human_(.+)$/)

    if belonging_method_match
      attribute_name = belonging_method_match[1]
      case belonging_method_match[2]
      when '='
        attribute_class = (try(attribute_name) || try("build_#{attribute_name}")).class
        try("#{attribute_name}=", args[0].present? && attribute_class.find(args[0]))
      else
        try(attribute_name)&.id
      end
    elsif human_attr_method_match
      attribute_name = human_attr_method_match[1]
      begin
        self.class.human_enum_name!(attribute_name, try(attribute_name))
      rescue I18n::MissingTranslationData
        try(attribute_name)
      end
    else
      super
    end
  end

  def respond_to_missing?(method, *args)
    method.match(/^belonging_(.+)_id(=?)$/) || method.match(/^human_(.+)$/) || super
  end
end
