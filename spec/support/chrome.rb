# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each, type: :system) do
    if ENV["SHOW_BROWSER"] == "true"
      driven_by :selenium_chrome
    else
      driven_by :selenium, using: :headless_chrome, screen_size: SIZE_1400x1400
    end
  end
end
