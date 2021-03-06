require 'spec_helper'

describe HouseholdMembershipAudit do

  before do
    @original_household = Household.create
    @new_houshold = Household.create
    @member = FactoryBot.create(:member, :household => @original_household)
  end

  it "should create an initial 'join' audit for new household membership " do
    expect(@member.household_membership_audits.count).to eq(1)
    expect(@member.household_membership_audits[0].household).to eq(@original_household)
  end

  describe "it should audit household moves" do

    before do
      @member.household = @new_household
      @member.save!
    end

    it "should create 2 new audits" do
      expect(@member.household_membership_audits.count).to eq(3)
    end


    it "should create a 'join' audit when moving to a new household" do
      @member.household_membership_audits[1].household == @original_household
      @member.household_membership_audits[1].event == 'left'
    end

    it "should create a 'leave' audit when moving to a new household" do
      @member.household_membership_audits[2].household == @new_household
      @member.household_membership_audits[2].event == 'joined'
    end
  end

end

# == Schema Information
#
# Table name: household_membership_audits
#
#  id           :integer(4)      not null, primary key
#  household_id :integer(4)
#  member_id    :integer(4)
#  event        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

