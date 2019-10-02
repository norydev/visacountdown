# frozen_string_literal: true

describe VisaCountdown::TypeNormalizer do
  include described_class

  let(:first_period)  { {first_day: Date.new(2019,  1,  1), last_day: Date.new(2019,  1, 10)} }
  let(:second_period) { {first_day: Date.new(2019,  2,  1), last_day: Date.new(2019,  2, 10)} }

  describe "#normalize_period" do
    it "returns a VisaCountdown::Period when given a hash" do
      output = normalize_period(first_period)

      expect(output).to eq(VisaCountdown::Period.new(first_period))
    end

    it "returns a VisaCountdown::Period when given a VisaCountdown::Period" do
      input  = VisaCountdown::Period.new(first_day: Date.new(2019,  1,  1), last_day: Date.new(2019,  1, 10))
      output = normalize_period(input)

      expect(output).to eq(input)
    end
  end

  describe "#normalize_periods" do
    it "returns an array of VisaCountdown::Period when given an array of hashes" do
      output = normalize_periods([first_period, second_period])

      expect(output).to eq([VisaCountdown::Period.new(first_period), VisaCountdown::Period.new(second_period)])
    end

    it "returns an array of VisaCountdown::Period when given multiple hashes" do
      output = normalize_periods(first_period, second_period)

      expect(output).to eq([VisaCountdown::Period.new(first_period), VisaCountdown::Period.new(second_period)])
    end

    it "returns an array of VisaCountdown::Period when given an array of VisaCountdown::Period" do
      input = [VisaCountdown::Period.new(first_period), VisaCountdown::Period.new(second_period)]
      output = normalize_periods(input)

      expect(output).to eq(input)
    end

    it "returns an array of VisaCountdown::Period when given multiple instances of VisaCountdown::Period" do
      output = normalize_periods(VisaCountdown::Period.new(first_period), VisaCountdown::Period.new(second_period))

      expect(output).to eq([VisaCountdown::Period.new(first_period), VisaCountdown::Period.new(second_period)])
    end

    it "returns an array of VisaCountdown::Period when a mixed array of hashes and instances of VisaCountdown::Period" do
      output = normalize_periods([first_period, VisaCountdown::Period.new(second_period)])

      expect(output).to eq([VisaCountdown::Period.new(first_period), VisaCountdown::Period.new(second_period)])
    end

    it "returns an array of VisaCountdown::Period when a mix of hashes and instances of VisaCountdown::Period as multiple params" do
      output = normalize_periods(first_period, VisaCountdown::Period.new(second_period))

      expect(output).to eq([VisaCountdown::Period.new(first_period), VisaCountdown::Period.new(second_period)])
    end
  end
end
