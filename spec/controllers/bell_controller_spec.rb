require 'spec_helper'

describe BellController do

  describe "GET 'ring'" do
    it "returns http success" do
      get 'ring'
      response.should be_success
    end
  end

end
