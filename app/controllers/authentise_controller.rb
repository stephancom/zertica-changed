class AuthentiseController < ApplicationController

############
require 'uri'
require 'rest_client'
require 'json'
helper_method :grab_partner_token

@api_partner_key = 'ZSBzaG9y-dCB2ZWhl-bWVuY2Ug-b2YgYW55-IGNhcm5h-bCB=='
def grab_partner_token
  url = URI.encode('http://widget.sendshapes.com:3000/api3/api_create_partner_token?api_key=ZSBzaG9y-dCB2ZWhl-bWVuY2Ug-b2YgYW55-IGNhcm5h-bCB==')

  @response = RestClient.get(url)
  @data = JSON.parse(@response)

end

#############








end
