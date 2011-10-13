require 'spec_helper'

describe Household do
  it "should default to a $0.00 balance" do
    Household.create!.balance.should == 0
  end

  describe "#credit!" do
    before do
      @household = Household.create!
    end

    it "should add the amount of credit to balance" do
      balance = @household.balance
      @household.credit!(BigDecimal.new("5"))
      @household.balance.should == balance + 5
    end

    it "should not allow credits <= 0" do
      lambda { @household.credit!(BigDecimal.new("-5")) }.should raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#debit!" do
    before do
      @household = Household.create!
    end

    it "should subtract the amount of debit to balance" do
      balance = @household.balance
      @household.debit!(BigDecimal.new("5"))
      @household.balance.should == balance - 5
    end

    it "should not allow debits <= 0" do
      lambda { @household.debit!(BigDecimal.new("-5")) }.should raise_error(ActiveRecord::RecordInvalid)
    end
  end

  pending "should be impossible to change balance without creating a transaction"

  describe ".find_by_keywords" do
    before do
      @joe_and_sams_house = Factory.create(:household)
      Factory.create(:member, first_name: "Joseph", household: @joe_and_sams_house)
      Factory.create(:member, first_name: "Sam", household: @joe_and_sams_house)

      @samanthas_house = Factory.create(:household)
      Factory.create(:member, first_name: "Samantha", last_name: "Pierce", household: @samanthas_house)
    end

    describe "when given then empty string" do
      subject { Household.find_by_keywords("") }
      it { should include(@samanthas_house) }
      it { should include(@joe_and_sams_house) }
    end

    describe "member's name matches exactly" do
      subject { Household.find_by_keywords("Samantha") }
      it { should include(@samanthas_house) }
      it { should_not include(@joe_and_sams_house) }
    end

    describe "member's name matches partially" do
      subject { Household.find_by_keywords("Jos") }
      it { should include(@joe_and_sams_house) }
      it { should_not include(@samanthas_house) }
    end

    describe "name matches multiple households" do
      subject { Household.find_by_keywords("Sam") }
      it { should include(@samanthas_house) }
      it { should include(@joe_and_sams_house) }
    end

    describe "when name matches, but with different caps" do
      subject { Household.find_by_keywords("sam") }
      it { should include(@samanthas_house) }
      it { should include(@joe_and_sams_house) }
    end

    describe "when last name is matched" do
      subject { Household.find_by_keywords("Pierce") }
      it { should include(@samanthas_house) }
      it { should_not include(@joe_and_sams_house) }
    end

    describe "with mulitple keywords" do

      describe "when we're specifying first and last name" do
        subject { Household.find_by_keywords("sam pierce") }
        it { should include(@samanthas_house) }
        it { should include(@joe_and_sams_house) }
      end

      describe "when we're specifiying multiple first names" do
        subject { Household.find_by_keywords("Sam Joseph") }
        it { should include(@samanthas_house) }
        it { should include(@joe_and_sams_house) }
      end
    end
  end
end
