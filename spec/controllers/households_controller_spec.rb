require 'spec_helper'

describe HouseholdsController do
  before do
    controller.class.skip_before_action :authenticate_user!, raise: false
  end

  describe "index" do
    it "should allow csv download" do
      get :index, :format => :csv
      expect(response).to be_success
    end
  end

end
