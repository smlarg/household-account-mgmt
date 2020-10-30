require 'spec_helper'

describe MembersController do
  before do
    controller.class.skip_before_action :authenticate_user!, raise: false
  end

  describe "index" do
    it "should allow csv download" do
      get :index, :format => :csv
      expect(response).to be_successful
    end
  end

end
