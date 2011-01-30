require 'spec_helper'

describe TransactionsController do
  before do
    @household = stub_model(Household, {:id => 1})
    Household.stub(:find) { @household }
    controller.stub(:authenticate_user!) { true }
  end

  def mock_user(stubs={})
    (@mock_user ||= mock_model(User).as_null_object).tap do |user|
      user.stub(stubs) unless stubs.empty?
    end
  end

  def mock_transaction(stubs={})
    (@mock_transaction ||= mock_model(Transaction).as_null_object).tap do |transaction|
      transaction.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all transactions as @transactions" do
      Transaction.stub(:all) { [mock_transaction] }
      get :index, {:household_id => 1}
      assigns(:transactions).should eq([mock_transaction])
    end
  end

  describe "GET show" do
    it "assigns the requested transaction as @transaction" do
      Transaction.stub(:find).with("37") { mock_transaction }
      get :show, {:household_id => 1, :id => "37"}
      assigns(:transaction).should be(mock_transaction)
    end
  end

  describe "GET new" do
    it "assigns a new transaction as @transaction" do
      Transaction.stub(:new) { mock_transaction }
      get :new
      assigns(:transaction).should be(mock_transaction)
    end
  end

  describe "GET edit" do
    it "assigns the requested transaction as @transaction" do
      Transaction.stub(:find).with("37") { mock_transaction }
      get :edit, {:id => "37", :household_id => 1}
      assigns(:transaction).should be(mock_transaction)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created transaction as @transaction" do
        Transaction.stub(:new).with({'these' => 'params'}) { mock_transaction(:save => true) }
        post :create,{:household_id => 1, :transaction => {'these' => 'params'}}
        assigns(:transaction).should be(mock_transaction)
      end

      it "redirects to the created transaction" do
        Transaction.stub(:new) { mock_transaction(:save => true) }
        post :create, {:household_id => 1, :transaction => {}}
        response.should redirect_to(transaction_url(mock_transaction))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved transaction as @transaction" do
        Transaction.stub(:new).with({'these' => 'params'}) { mock_transaction(:save => false) }
        post :create, :transaction => {'these' => 'params'}
        assigns(:transaction).should be(mock_transaction)
      end

      it "re-renders the 'new' template" do
        Transaction.stub(:new) { mock_transaction(:save => false) }
        post :create, :transaction => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested transaction" do
        Transaction.should_receive(:find).with("37") { mock_transaction }
        mock_transaction.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => "37", :household_id => 1, :transaction => {'these' => 'params'}}
      end

      it "assigns the requested transaction as @transaction" do
        Transaction.stub_chain(:for_household, :find) { mock_transaction(:update_attributes => true) }
        put :update, {:id => "1", :household_id => 1}
        assigns(:transaction).should be(mock_transaction)
      end

      it "redirects to the transaction" do
        Transaction.stub_chain(:for_household, :find) { mock_transaction(:update_attributes => true) }
        put :update, {:id => "1", :household_id => 1}
        response.should redirect_to(transaction_url(mock_transaction))
      end
    end

    describe "with invalid params" do
      it "assigns the transaction as @transaction" do
        Transaction.stub_chain(:for_household, :find) { mock_transaction(:update_attributes => false) }
        put :update, {:id => "1", :household_id => 1}
        assigns(:transaction).should be(mock_transaction)
      end

      it "re-renders the 'edit' template" do
        Transaction.stub_chain(:for_household, :find) { mock_transaction(:update_attributes => false) }
        put :update, {:id => "1", :household_id => 1}
        response.should render_template("edit")
      end
    end

  end
end
