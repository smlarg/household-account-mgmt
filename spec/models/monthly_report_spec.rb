require "spec_helper"

describe MonthlyReport do

  describe "#purchases_amount" do
    subject { MonthlyReport.all.map &:purchases_amount }

    context "with 1 purchase" do
      before do
        FactoryBot.create(:purchase, :amount => 50, :created_at => Date.parse("January 1, 2011"))
      end
      it {is_expected.to eq([50])}
    end

    context "with 2 purchases on the same day" do
      before do
        FactoryBot.create(:purchase, :amount => 50, :created_at => Date.parse("January 1, 2011"))
        FactoryBot.create(:purchase, :amount => 50, :created_at => Date.parse("January 1, 2011"))
      end
      it {is_expected.to eq([100])}
    end

    context "with 2 purchases on different days" do
      before do
        FactoryBot.create(:purchase, :amount => 50, :created_at => Date.parse("January 1, 2011"))
        FactoryBot.create(:purchase, :amount => 50, :created_at => Date.parse("January 31, 2011"))
      end
      it {is_expected.to eq([100])}
    end

    context "with a purchase from a different month" do
      before do
        FactoryBot.create(:purchase, :amount => 50, :created_at => Date.parse("January 1, 2011"))
        FactoryBot.create(:purchase, :amount => 50, :created_at => Date.parse("February 1, 2011"))
      end
      it {is_expected.to eq([50, 50])}
    end

    context "with a purchase from a different year" do
      before do
        FactoryBot.create(:purchase, :amount => 50, :created_at => Date.parse("January 1, 2011"))
        FactoryBot.create(:purchase, :amount => 50, :created_at => Date.parse("January 1, 2010"))
      end
      it {is_expected.to eq([50,50])}
    end
  end

  describe "#investments_amount" do
    subject { MonthlyReport.all.map &:investments_amount }

    context "with 1 investment" do
      before do
        FactoryBot.create(:investment, :amount => 50, :created_at => Date.parse("January 1, 2011"))
      end
      it {is_expected.to eq([50])}
    end

    context "with 2 investments on the same day" do
      before do
        @transaction = FactoryBot.create(:investment, :amount => 50, :created_at => Date.parse("January 1, 2011"))
        FactoryBot.create(:investment, :amount => 50, :created_at => Date.parse("January 1, 2011"))
      end
      it {is_expected.to eq([100])}

      context "when one of those transactions is voided" do
        before do
          @transaction.void = true
          @transaction.save
        end
        it { is_expected.to eq([50]) }
      end
    end

    context "with 2 investments on different days" do
      before do
        FactoryBot.create(:investment, :amount => 50, :created_at => Date.parse("January 1, 2011"))
        FactoryBot.create(:investment, :amount => 50, :created_at => Date.parse("January 31, 2011"))
      end
      it {is_expected.to eq([100])}
    end

    context "with a investment from a different month" do
      before do
        FactoryBot.create(:investment, :amount => 50, :created_at => Date.parse("January 1, 2011"))
        FactoryBot.create(:investment, :amount => 50, :created_at => Date.parse("February 1, 2011"))
      end
      it {is_expected.to eq([50, 50])}
    end

    context "with a investment from a different year" do
      before do
        FactoryBot.create(:investment, :amount => 50, :created_at => Date.parse("January 1, 2011"))
        FactoryBot.create(:investment, :amount => 50, :created_at => Date.parse("January 1, 2010"))
      end
      it {is_expected.to eq([50,50])}
    end

  end

end
