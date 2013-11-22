Airbrake.configure do |config|
  config.api_key = '620320dc2e6ef4915b86ab6defcdfbad'
  config.host    = 'errors.stephan.com'
  config.port    = 80
  config.secure  = config.port == 443
end
