# frozen_string_literal: true
RSpec::Matchers.define :have_immutable_attribute do |expected|
  match do |actual|
    instance = actual
    model = instance.class
    attribute_name = expected

    factory_name = FactoryGirl.factories.instance_variable_get('@items')
                              .select { |_name, factory| factory.build_class == model }
                              .keys.first
    instance.assign_attributes(FactoryGirl.build(factory_name).attributes) if factory_name.present?
    instance[attribute_name] = true if instance[attribute_name].blank?
    instance.save!

    new_value = false

    if factory_name.present?
      new_value = FactoryGirl.attributes_for(factory_name)[attribute_name]

      new_value = false if new_value.blank? || new_value == instance[attribute_name]
    else
      new_value = false
    end

    instance[attribute_name] = new_value

    !instance.valid? && instance.errors.key?(attribute_name)
  end
end
