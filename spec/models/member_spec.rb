require 'spec_helper'

describe Member do

  def household
    @household ||= Household.create!
  end

  describe "#household" do

    it "should belong to the assigned household if one was specified on creation" do
      m = FactoryGirl.build(:member)
      m.household = household
      m.save!
      expect(m.household).to eq(household)

      #reload household to verify relation persisted in DB
      db_household = Household.find(household.id)
      expect(db_household.members).to include m
    end

    it "should have a new household assigned on creation if one wasn't specified" do
      m = FactoryGirl.build(:member)
      m.save!
      expect(m.household).not_to be_nil
      expect(m.household.members).to eq([m])
    end

    describe "changing households" do
      let(:m) { FactoryGirl.create(:member) }

      it "should not allow last member to leave household with outstanding balance" do
        m.household.transactions.create(amount: 5, credit: true)
        m.household= @household
        expect(m).not_to be_valid
      end

      it "should allow last member to leave household with no outstanding balance" do
        m.household.transactions.create(amount: 5, credit: true)
        m.household.transactions.create(amount: 5, credit: false)
        m.household= @household
        expect(m).to be_valid
      end

    end

  end

  describe ".find_by_keywords" do
    before(:all) do
      Member.destroy_all
      @members = []
      @members << @joseph = FactoryGirl.create(:member, first_name: "Joseph")
      @members << @sam = FactoryGirl.create(:member, first_name: "Sam", last_name: "St. John")
      @members << @samantha_pierce = FactoryGirl.create(:member, first_name: "Samantha", last_name: "Pierce")
    end

    after(:all) do
      @members.each &:destroy
    end

    describe "when given then empty string" do
      subject { Member.find_by_keywords("") }
      it { is_expected.to include(@samantha_pierce) }
      it { is_expected.to include(@joseph) }
      it { is_expected.to include(@sam) }
    end

    describe "member's name matches exactly" do
      subject { Member.find_by_keywords("Samantha") }
      it { is_expected.to include(@samantha_pierce) }
      it { is_expected.not_to include(@joseph) }
      it { is_expected.not_to include(@sam) }
    end

    describe "member's name matches partially" do
      subject { Member.find_by_keywords("Jos") }
      it { is_expected.to include(@joseph) }
      it { is_expected.not_to include(@samantha_pierce) }
      it { is_expected.not_to include(@sam) }
    end

    describe "name matches multiple households" do
      subject { Member.find_by_keywords("Sam") }
      it { is_expected.to include(@samantha_pierce) }
      it { is_expected.to include(@sam) }
      it { is_expected.not_to include(@joseph) }
    end

    describe "when name matches, but with different caps" do
      subject { Member.find_by_keywords("sam") }
      it { is_expected.to include(@samantha_pierce) }
      it { is_expected.to include(@sam) }
      it { is_expected.not_to include(@joseph) }
    end

    describe "when last name is matched" do
      subject { Member.find_by_keywords("Pierce") }
      it { is_expected.to include(@samantha_pierce) }
      it { is_expected.not_to include(@joseph) }
      it { is_expected.not_to include(@sam) }
    end

    describe "with mulitple keywords" do

      describe "when we're specifying first and last name" do
        subject { Member.find_by_keywords("sam pierce") }
        it { is_expected.to include(@samantha_pierce) }
        it { is_expected.to include(@sam) }
        it { is_expected.not_to include(@joseph) }
        it "shouldn't include a member multiple times" do
          expect(subject.length).to eq(2)
        end
      end

      describe "when we're specifiying multiple first names" do
        subject { Member.find_by_keywords("Sam Joseph") }
        it { is_expected.to include(@samantha_pierce) }
        it { is_expected.to include(@sam) }
        it { is_expected.to include(@joseph) }
      end

      describe "when there's a period in it" do
        subject { Member.find_by_keywords("st. john") }
        it { is_expected.to include @sam }
        it { is_expected.not_to include @samantha_pierce }
        it { is_expected.not_to include @joseph }
      end
    end

  end

  describe ".by_activity" do
    before(:all) do
      @active_member = FactoryGirl.create(:member, :active => true)
      @inactive_member = FactoryGirl.create(:member, :active => false)
    end

    after(:all) do
      @active_member.destroy
      @inactive_member.destroy
    end
  
    subject { Member.by_activity(:include_active => include_active, :include_inactive => include_inactive) }

    context "when searching for active only" do
      let(:include_active) { true }
      let(:include_inactive) { nil }
      it { is_expected.to include @active_member }
      it { is_expected.not_to include @inactive_member }
    end
    context "when searching for inactive only" do
      let(:include_active) { nil }
      let(:include_inactive) { true }
      it { is_expected.to include @inactive_member }
      it { is_expected.not_to include @active_member }
    end
    context "when searching for both" do
      let(:include_active) { true }
      let(:include_inactive) { true }
      it { is_expected.to include @active_member }
      it { is_expected.to include @active_member }
    end
    context "when searching for neither" do
      let(:include_active) { nil }
      let(:include_inactive) { nil }
      it { is_expected.to include @active_member }
      it { is_expected.to include @active_member }
    end
  end

end

# == Schema Information
#
# Table name: members
#
#  id           :integer(4)      not null, primary key
#  last_name    :string(255)
#  first_name   :string(255)
#  household_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  phone1       :string(255)
#  phone2       :string(255)
#  address1     :string(255)
#  address2     :string(255)
#  city         :string(255)
#  state        :string(255)
#  zip          :string(255)
#  notes        :text
#  active       :boolean(1)      default(TRUE)
#  email        :string(255)
#  fm_id        :integer(4)
#

