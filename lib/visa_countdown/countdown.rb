module VisaCountdown
  class Countdown
    attr_reader :periods, :latest_entry, :length_of_stay, :window_of_stay

    def initialize(periods: [], latest_entry: nil, length_of_stay: 90, window_of_stay: 180)
      @periods        = PeriodCollection.new(periods)
      @latest_entry   = latest_entry
      @length_of_stay = length_of_stay
      @window_of_stay = window_of_stay
    end

    def time_spent
      time_spent_on(latest_entry: latest_entry)
    end

    def remaining_time
      number  = remaining_time_on(date: status.date_for_remaining_time, latest_entry: status.latest_entry_for_remaining_time)
      number += 1 unless entry_has_happened?(date: status.date_for_remaining_time, latest_entry: status.latest_entry_for_remaining_time)
      number
    end
    alias_method :remaining_number_of_days, :remaining_time

    def exit_day
      date  = status.exit_date + remaining_time
      date -= 1 unless entry_has_happened?(date: status.date_for_remaining_time, latest_entry: status.latest_entry_for_remaining_time)
      date
    end
    alias_method :exit_date, :exit_day

    def next_entry
      next_entry_from(date: status.next_entry_date)
    end

    def quota_day
      status.quota_day
    end

    def situation
      status.situation
    end

    # private

    def status
      Status.new(self)
    end

    def time_spent_on(date: Date.today, periods: self.periods, latest_entry: nil)
      number_of_days = 0

      latest_date = latest_entry && (latest_entry - 1) < date ? latest_entry - 1 : date

      trimmed_periods = periods.trim(oldest_date: date - (window_of_stay - 1),
                                     latest_date: latest_date)

      if trimmed_periods.any?
        number_of_days += trimmed_periods.map(&:length).reduce(:+)
      end

      if latest_entry && entry_has_happened?(date: date, latest_entry: latest_entry)
        number_of_days += Period.new(first_day: latest_entry, last_day: date).length
      end

      number_of_days
    end

    def entry_has_happened?(date: Date.today, latest_entry: nil)
      latest_entry && latest_entry < date
    end

    def remaining_time_on(date: Date.today, latest_entry: nil)
      remaining_time = 0
      entry = latest_entry || date

      ((date + 1)..(entry + (length_of_stay - 1))).each do |day|
        if time_spent_on(date: day, latest_entry: entry, periods: periods) <= length_of_stay
          remaining_time += 1
        end
      end

      remaining_time
    end

    def next_entry_from(date: Date.today)
      waiting_time = 0

      (date..(date + length_of_stay)).each do |day|
        if periods.select { |period| period.include?(day - window_of_stay) }.none?
          waiting_time += 1
        end
      end

      date + waiting_time
    end
  end
end
