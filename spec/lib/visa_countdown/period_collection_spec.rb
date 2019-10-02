# frozen_string_literal: true

describe VisaCountdown::PeriodCollection do
  let(:first_period)  { {first_day: Date.new(2019,  1,  1), last_day: Date.new(2019,  1, 10)} }
  let(:second_period) { {first_day: Date.new(2019,  2,  1), last_day: Date.new(2019,  2, 10)} }

  subject { described_class.new(first_period, second_period) }

  describe "#==" do
    it "equals 2 collection whose periods are the same" do
      expect(subject == VisaCountdown::PeriodCollection.new(first_period, second_period)).to be true
    end
  end

  describe "#find_covering" do
    it "returns the period covering a date within first_day and last_day "\
       "of a period in the collection" do
      expect(subject.find_covering(Date.new(2019,  1,  5))).to eq VisaCountdown::Period.new(first_period)
    end

    it "returns the period covering first_day of a period" do
      expect(subject.find_covering(Date.new(2019,  1,  1))).to eq VisaCountdown::Period.new(first_period)
    end

    it "returns the period covering last_day of a period" do
      expect(subject.find_covering(Date.new(2019,  1,  10))).to eq VisaCountdown::Period.new(first_period)
    end

    it "returns nil if date is outside of any period" do
      expect(subject.find_covering(Date.new(2019,  1,  11))).to be nil
    end
  end

  describe "#include?" do
    it "includes a date within first_day and last_day of a period" do
      expect(subject.include?(Date.new(2019,  1,  5))).to be true
    end

    it "includes first_day of a period" do
      expect(subject.include?(Date.new(2019,  1,  1))).to be true
    end

    it "includes last_day of a period" do
      expect(subject.include?(Date.new(2019,  1,  10))).to be true
    end

    it "exclude a date outside of any period" do
      expect(subject.include?(Date.new(2019,  1,  11))).to be false
    end
  end

  describe "#remove_too_old" do
    it "removes a period whose last_day is before oldest_date" do
      result = subject.remove_too_old(Date.new(2019,  1, 12))

      expect(result).to contain_exactly(VisaCountdown::Period.new(second_period))
    end

    it "trims a period if it's first_day is before oldest_date, but last_day is after oldest_date" do
      result = subject.remove_too_old(Date.new(2019,  1, 5))

      expect(result).to contain_exactly(
        VisaCountdown::Period.new(first_day: Date.new(2019,  1,  5), last_day: Date.new(2019,  1, 10)),
        VisaCountdown::Period.new(second_period)
      )
    end
  end

  describe "#remove_future" do
    it "removes a period whose first_day is after latest_date" do
      result = subject.remove_future(Date.new(2019,  1, 12))

      expect(result).to contain_exactly(VisaCountdown::Period.new(first_period))
    end

    it "trims a period if it's first_day is before latest_date, but last_day is after latest_date" do
      result = subject.remove_future(Date.new(2019,  2, 5))

      expect(result).to contain_exactly(
        VisaCountdown::Period.new(first_period),
        VisaCountdown::Period.new(first_day: Date.new(2019,  2,  1), last_day: Date.new(2019,  2,  5))
      )
    end
  end

  describe "#trim" do
    it "trims days on both sides of oldest_date and latest_date" do
      result = subject.trim(oldest_date: Date.new(2019,  1,  5), latest_date: Date.new(2019,  2,  5))

      expect(result).to contain_exactly(
        VisaCountdown::Period.new(first_day: Date.new(2019,  1,  5), last_day: Date.new(2019,  1, 10)),
        VisaCountdown::Period.new(first_day: Date.new(2019,  2,  1), last_day: Date.new(2019,  2,  5))
      )
    end
  end
end
