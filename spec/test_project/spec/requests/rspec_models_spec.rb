require 'rails_helper'

RSpec.describe "RspecModels", :type => :request do
  describe "GET /rspec_models" do
    it "works! (now write some real specs)" do
      get rspec_models_path
      expect(response.status).to be(200)
    end
  end
end
