require "spec_helper"

describe ActiveChatsController do
  describe "routing" do

    it "routes to #index" do
      get("/active_chats").should route_to("active_chats#index")
    end

    it "routes to #new" do
      get("/active_chats/new").should route_to("active_chats#new")
    end

    it "routes to #show" do
      get("/active_chats/1").should route_to("active_chats#show", :id => "1")
    end

    it "routes to #edit" do
      get("/active_chats/1/edit").should route_to("active_chats#edit", :id => "1")
    end

    it "routes to #create" do
      post("/active_chats").should route_to("active_chats#create")
    end

    it "routes to #update" do
      put("/active_chats/1").should route_to("active_chats#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/active_chats/1").should route_to("active_chats#destroy", :id => "1")
    end

  end
end
