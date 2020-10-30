require 'spec_helper'

describe Transaction do
  before do
    @household = Household.create!
  end

  it "should not allow negative amount" do
    t = Transaction.new(:amount => -1.20)
    #expect(t).to have(1).error_on(:amount)
    t.valid?
    expect(t.errors[:amount].size).to eq(1)
  end

  describe ".total_balance" do
    it "should accumulate balance of all transactions" do
      expect(Transaction.total_balance).to eq(0)
      Transaction.create!(:household => @household, :amount => 2.01, :credit => true)
      Transaction.create!(:household => @household, :amount => 1.10, :credit => true)
      expect(Transaction.total_balance).to eq(3.11)
    end

    it "should accumulate debits negatively" do
      expect(Transaction.total_balance).to eq(0)
      Transaction.create!(:household => @household, :amount => 2.01, :credit => true)
      Transaction.create!(:household => @household, :amount => 1.10, :credit => false)
      expect(Transaction.total_balance).to eq(0.91)
    end
  end

  describe "write-once transactions" do
    before do
      @credit = Transaction.create!(:household => @household, :amount => 2.01, :credit => true)
      @household2 = Household.create!
    end

    it "should set amount, household, and balance via mass assignment on creation" do
      t = Transaction.create!(:household => @household, :amount => 2.01, :credit => true)
      expect(t.new_record?).to eq(false)
      expect(t.household).to eq(@household)
      expect(t.amount).to eq(2.01)
      expect(t.credit).to eq(true)
    end

    it "should not let you update the amount via mass assignment" do
      @credit.update_attributes({:amount => 3.01})
      # model attribute will appear updated, but not actually persisted to DB, hence the reload.
      # https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2132-confusing-behavior-with-attr_readonly#ticket-2132-14
      @credit.save!
      expect(@credit.reload.amount).to eq(2.01)
    end

    it "should not let you update the household via mass assignment" do
      @credit.update_attributes({:household => @household2})
      # model attribute will appear updated, but not actually persisted to DB, hence the reload.
      # https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2132-confusing-behavior-with-attr_readonly#ticket-2132-14
      @credit.save!
      expect(@credit.reload.household).to eq(@household)
    end

    it "should not let you update the credit attribute via mass assignment" do
      @credit.update_attributes({:credit => false})
      # model attribute will appear updated, but not actually persisted to DB, hence the reload.
      # https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2132-confusing-behavior-with-attr_readonly#ticket-2132-14
      @credit.save!
      expect(@credit.reload.credit).to eq(true)
    end
  end

  describe ".amount_purchased_this_week" do
    subject { Transaction.amount_purchased_this_week }

    context "when there have been no transactions" do
      it { is_expected.to eq(0) }
    end

    context "when there have been some purchases" do
      before do
        FactoryBot.create(:purchase, :amount => 20)
        FactoryBot.create(:purchase, :amount => 30)
      end

      it { is_expected.to eq(50) }
    end

    context "when there have been some purchases and some investments" do
      before do
        FactoryBot.create(:purchase, :amount => 20)
        FactoryBot.create(:investment, :amount => 30)
      end

      it { is_expected.to eq(20) }
    end

    context "when there are purchases older than a week" do
      before do
        FactoryBot.create(:purchase, :amount => 10, :created_at => 7.1.days.ago)
        FactoryBot.create(:purchase, :amount => 5, :created_at => 6.9.days.ago)
        FactoryBot.create(:purchase, :amount => 20, :created_at => Date.today)
      end

      it { is_expected.to eq(25) }
    end

  end

end

# == Schema Information
#
# Table name: transactions
#
#  id           :integer(4)      not null, primary key
#  amount       :decimal(8, 2)   not null
#  credit       :boolean(1)      not null
#  message      :string(255)
#  household_id :integer(4)      not null
#  created_at   :datetime
#  updated_at   :datetime
#

