# frozen_string_literal: true

module VisaCountdown
  module TypeNormalizer
    def normalize_period(period)
      if period.is_a?(VisaCountdown::Period)
        period
      else
        VisaCountdown::Period.new(period)
      end
    end

    def normalize_periods(*periods)
      periods.flatten.map { |period| normalize_period(period) }
    end
  end
end
