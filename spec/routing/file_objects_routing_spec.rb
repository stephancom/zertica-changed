require "spec_helper"

describe FileObjectsController do
  describe "routing" do

    it "routes to #index" do
      get("/file_objects").should route_to("file_objects#index")
    end

    it "routes to #new" do
      get("/file_objects/new").should route_to("file_objects#new")
    end

    it "routes to #show" do
      get("/file_objects/1").should route_to("file_objects#show", :id => "1")
    end

    it "routes to #edit" do
      get("/file_objects/1/edit").should route_to("file_objects#edit", :id => "1")
    end

    it "routes to #create" do
      post("/file_objects").should route_to("file_objects#create")
    end

    it "routes to #update" do
      put("/file_objects/1").should route_to("file_objects#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/file_objects/1").should route_to("file_objects#destroy", :id => "1")
    end

  end
end
