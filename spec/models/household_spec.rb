require 'spec_helper'

describe Household do
  pending " should allow merging households"

  it "should default to a $0.00 balance" do
    Household.create!.balance.should == 0
  end
end
