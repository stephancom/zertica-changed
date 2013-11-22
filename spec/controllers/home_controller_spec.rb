require 'spec_helper'

describe HomeController do
	describe "GET 'index'" do
		it "should be successful" do
			get 'index'
			response.should be_success
		end
	end

	describe "for an anonymous user" do
		it "should description" do
			get 'index'
			response.should_not be_redirect      
		end
	end

	describe "for a logged in user" do
		login_user

		it "should show the project list" do
			get 'index'
			response.should redirect_to(projects_path)
		end
	end
end
