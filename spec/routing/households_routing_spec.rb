require "spec_helper"

describe HouseholdsController do
  describe "routing" do

    it "recognizes and generates #index" do
      expect({ :get => "/households" }).to route_to(:controller => "households", :action => "index")
    end

    it "recognizes and generates #new" do
      expect({ :get => "/households/new" }).to route_to(:controller => "households", :action => "new")
    end

    it "recognizes and generates #show" do
      expect({ :get => "/households/1" }).to route_to(:controller => "households", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      expect({ :get => "/households/1/edit" }).to route_to(:controller => "households", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      expect({ :post => "/households" }).to route_to(:controller => "households", :action => "create")
    end

    it "recognizes and generates #update" do
      expect({ :put => "/households/1" }).to route_to(:controller => "households", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      expect({ :delete => "/households/1" }).to route_to(:controller => "households", :action => "destroy", :id => "1")
    end

  end
end
