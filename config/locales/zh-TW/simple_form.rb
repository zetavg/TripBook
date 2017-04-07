# frozen_string_literal: true
{
  'zh-TW': {
    simple_form: {
      labels: YAML.load(File.read(File.join(Rails.root, 'config', 'locales', 'zh-TW', 'models.yml')))
                  .dig('zh-TW', 'models', 'attributes')
    }
  }
}
