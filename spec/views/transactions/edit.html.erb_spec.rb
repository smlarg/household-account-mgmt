require 'spec_helper'

describe "transactions/edit.html.erb" do
  before(:each) do
    @transaction = assign(:transaction, stub_model(Transaction,
      :amount => "9.99",
      :credit => false,
      :message => "MyString",
      :household_id => 1
    ))
  end

  it "renders the edit transaction form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => transaction_path(@transaction), :method => "post" do
      assert_select "input#transaction_amount", :name => "transaction[amount]"
      assert_select "input#transaction_credit_true", :name => "transaction[credit]"
      assert_select "input#transaction_credit_false", :name => "transaction[credit]"
      assert_select "input#transaction_message", :name => "transaction[message]"
      assert_select "select#transaction_household_id", :name => "transaction[household_id]"
    end
  end
end
