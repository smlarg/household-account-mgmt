require 'spec_helper'

describe "Transactions" do
  before do
    @household = stub_model(Household, {:id => 1})

    TransactionsController.skip_before_action :authenticate_user!, raise: false
  end

  describe "GET /transactions" do
    it "works!" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get all_transactions_url, params: {}
      expect(response.status).to be(200)
    end
  end
  describe "GET /household/1/transactions" do
    it "works!" do
      household = FactoryBot.create(:household)
      expect(Household).to receive(:find).with("1") { household }
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get household_transactions_url(:household_id => 1), params: {}
      expect(response.status).to be(200)
    end
  end

end
