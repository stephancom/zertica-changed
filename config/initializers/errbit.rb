Airbrake.configure do |config|
  config.api_key = '711f663f4ad595db6362136033a46909'
  config.host    = 'errors.stephan.com'
  config.port    = 80
  config.secure  = config.port == 443
end
