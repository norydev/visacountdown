# frozen_string_literal: true

module VisaCountdown
  class PeriodCollection
    include Enumerable
    include TypeNormalizer

    attr_reader :periods

    def initialize(*periods)
      @periods = normalize_periods(*periods)
    end

    def each(&block)
      periods.each(&block)
    end

    def ==(other_collection)
      self.map(&:itself).sort_by(&:first_day) == other_collection.map(&:itself).sort_by(&:first_day)
    end

    def find_covering(date)
      self.find { |period| period.include?(date) }
    end

    def include?(date)
      !!find_covering(date)
    end

    # remove the period if it is entirely before oldest date
    # remove days of the period that are before the oldest day
    def remove_too_old(oldest_date)
      PeriodCollection.new(
        self.reject { |period| period.last_day < oldest_date }.map do |period|
          Period.new(first_day: [oldest_date, period.first_day].max, last_day: period.last_day)
        end
      )
    end

    # remove period if it is totally in the future
    # remove days of the period that are in the future
    def remove_future(latest_day)
      PeriodCollection.new(
        self.reject { |period| period.first_day > latest_day }.map do |period|
          Period.new(first_day: period.first_day, last_day: [period.last_day, latest_day].min)
        end
      )
    end

    # keep only days that are within a window between oldest_date and latest_date
    def trim(oldest_date:, latest_date:)
      self.remove_too_old(oldest_date)
          .remove_future(latest_date)
    end
  end
end
