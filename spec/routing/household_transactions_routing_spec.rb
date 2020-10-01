require "spec_helper"

describe TransactionsController do
  describe "routing" do

    it "recognizes and generates #index" do
      expect({ :get => "/households/1/transactions" }).to route_to(:controller => "transactions", :household_id => "1", :action => "index")
    end

    it "recognizes and generates #new" do
      expect({ :get => "/households/1/transactions/new" }).to route_to(:controller => "transactions", :household_id => "1", :action => "new")
    end

    it "recognizes and generates #show" do
      expect({ :get => "/households/1/transactions/1" }).to route_to(:controller => "transactions", :household_id => "1", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      expect({ :get => "/households/1/transactions/1/edit" }).to route_to(:controller => "transactions", :household_id => "1", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      expect({ :post => "/households/1/transactions" }).to route_to(:controller => "transactions", :household_id => "1", :action => "create")
    end

    it "recognizes and generates #update" do
      expect({ :put => "/households/1/transactions/1" }).to route_to(:controller => "transactions", :household_id => "1", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      expect({ :delete => "/households/1/transactions/1" }).to route_to(:controller => "transactions", :household_id => "1", :action => "destroy", :id => "1")
    end

  end
end
