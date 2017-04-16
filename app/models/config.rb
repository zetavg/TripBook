# frozen_string_literal: true
class Config < Settingslogic
  source Rails.root.join('config', 'application.yml')
  namespace Rails.env

  class << self
    def info
      JSON.pretty_generate(all)
    end

    def all
      shield_sensitive_data(to_hash)
    end

    def shield_sensitive_data(hash)
      Hash[hash.map do |key, value|
        if value.is_a? Hash
          value = shield_sensitive_data(value)
        elsif key =~ /key/ || key =~ /secret/ || key =~ /pepper$/ ||
              key =~ /KEY/ || key =~ /SECRET/ || key =~ /PEPPER$/ ||
              key =~ /DATABASE/ || key =~ /SQL/
          value = value[0..7] + value.gsub(/..?.?/, '*') unless value.nil?
        end
        [key, value]
      end]
    end
  end
end
