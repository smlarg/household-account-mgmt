require 'spec_helper'

describe "Households" do
  before do
    HouseholdsController.skip_before_action :authenticate_user!, raise: false
  end
  describe "GET /households" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get households_path, params: {}
      expect(response.status).to be(200)
    end
  end
end
