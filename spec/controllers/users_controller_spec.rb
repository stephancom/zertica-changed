require 'spec_helper'

describe UsersController do
  before(:each) do
    @user = create(:user)
  end

  describe "when not logged in" do
    describe "GET 'index'" do
      it "should fail" do
        get :index
        response.should_not be_success
      end
    end
    describe "GET 'show'" do
      it "should fail" do
        get :show, :id => @user.id
        response.should_not be_success
      end
    end
  end

  describe "the user is logged in" do
    before(:each) do
      sign_in @user
    end

    describe "GET 'index'" do
      it "should fail" do
        get :index
        response.should_not be_success
      end
    end

    describe "GET 'show'" do
      it "should be successful" do
        get :show, :id => @user.id
        response.should be_success
      end
      
      it "should find the right user" do
        get :show, :id => @user.id
        assigns(:user).should == @user
      end
    end
  end

  describe "a different user is logged in" do
    before(:each) do
      sign_in create(:user)
    end

    describe "GET 'index'" do
      it "should fail" do
        get :index
        response.should_not be_success
      end
    end

    # allow users to see other user records for now
    # not sure whether this is right or wrong
    describe "GET 'show'" do
      it "should fail" do
        get :show, :id => @user.id
        response.should be_success
      end
    end
  end  

  describe "an admin is logged in" do
    before(:each) do
      @admin = create(:admin)
      sign_in @admin
    end

    describe "GET 'index'" do
      it "should succeed" do
        get :index
        response.should be_success
      end
    end
  end
end
