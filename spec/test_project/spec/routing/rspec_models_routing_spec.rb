require "rails_helper"

RSpec.describe RspecModelsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/rspec_models").to route_to("rspec_models#index")
    end

    it "routes to #new" do
      expect(:get => "/rspec_models/new").to route_to("rspec_models#new")
    end

    it "routes to #show" do
      expect(:get => "/rspec_models/1").to route_to("rspec_models#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/rspec_models/1/edit").to route_to("rspec_models#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/rspec_models").to route_to("rspec_models#create")
    end

    it "routes to #update" do
      expect(:put => "/rspec_models/1").to route_to("rspec_models#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/rspec_models/1").to route_to("rspec_models#destroy", :id => "1")
    end

  end
end
