# frozen_string_literal: true

module VisaCountdown
  class Period
    attr_accessor :first_day, :last_day

    def initialize(first_day:, last_day:)
      @first_day = first_day
      @last_day = last_day
    end

    def length
      (last_day - first_day).to_i + 1
    end

    def ==(other_period)
      first_day == other_period.first_day && last_day == other_period.last_day
    end

    def include?(date)
      (first_day..last_day).include?(date)
    end
  end
end
