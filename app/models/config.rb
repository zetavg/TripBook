class Config < Settingslogic
  source Rails.root.join('config', 'application.yml')
  namespace Rails.env
end
