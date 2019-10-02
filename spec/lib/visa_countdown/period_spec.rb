# frozen_string_literal: true

describe VisaCountdown::Period do
  let(:raw_period) { {first_day: Date.new(2019,  1,  1), last_day: Date.new(2019,  1, 10)} }
  subject { described_class.new(raw_period) }

  its(:length) { is_expected.to eq(10) }

  describe "#==" do
    it "equals 2 periods whose first_day are the same, and last_day are the same" do
      expect(subject == VisaCountdown::Period.new(raw_period)).to be true
    end
  end

  describe "#include?" do
    it "includes a date within first_day and last_day" do
      expect(subject.include?(Date.new(2019,  1,  5))).to be true
    end

    it "includes first_day" do
      expect(subject.include?(Date.new(2019,  1,  1))).to be true
    end

    it "includes last_day" do
      expect(subject.include?(Date.new(2019,  1,  10))).to be true
    end

    it "exclude a date outside of range" do
      expect(subject.include?(Date.new(2019,  1,  11))).to be false
    end
  end
end
