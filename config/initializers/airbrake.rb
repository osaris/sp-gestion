# -*- encoding : utf-8 -*-
Airbrake.configure do |config|
  config.api_key = SPG_CONFIG[:airbrake_api_key]
end