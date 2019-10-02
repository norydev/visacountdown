# frozen_string_literal: true

module VisaCountdown
  class Status
    def initialize(countdown)
      @countdown = countdown
    end

    def situation
      status[:situation]
    end

    def date_for_remaining_time
      status[:date_for_remaining_time]
    end

    def latest_entry_for_remaining_time
      status[:latest_entry_for_remaining_time]
    end

    def exit_date
      status[:exit_date]
    end

    def next_entry_date
      status[:next_entry_date]
    end

    def quota_day
      status[:quota_day]
    end

    private

    attr_reader :countdown

    def status
      time_spent = countdown.time_spent_on(latest_entry: countdown.latest_entry)

      if time_spent < countdown.length_of_stay
        if countdown.entry_has_happened?(latest_entry: countdown.latest_entry)
          return {
            situation:                       "inside_ok",
            date_for_remaining_time:         Date.today,
            latest_entry_for_remaining_time: countdown.latest_entry,
            exit_date:                       Date.today
          }
        elsif countdown.periods.include?(Date.today)
          if countdown.time_spent_on(date: countdown.periods.find_covering(Date.today).last_day) > countdown.length_of_stay
            return {
              situation:                       "current_too_long",
              date_for_remaining_time:         Date.today,
              latest_entry_for_remaining_time: countdown.periods.find_covering(Date.today).first_day,
              exit_date:                       Date.today
            }
          elsif countdown.time_spent_on(date: countdown.periods.find_covering(Date.today).last_day) == countdown.length_of_stay
            return quota_used_on(date: countdown.periods.find_covering(Date.today).last_day + 1, future: "will_be_", quota: countdown.periods.find_covering(Date.today).last_day)
          else
            # check if one next is too long otherwise inside ok
            return one_future_period_too_long || {
              situation:               "inside_ok",
              date_for_remaining_time: countdown.latest_entry || countdown.periods.find_covering(Date.today).last_day + 1,
              exit_date:               countdown.latest_entry || countdown.periods.find_covering(Date.today).last_day + 1
            }
          end
        else
          # check if one next is too long otherwise outside ok
          return one_future_period_too_long || {
            situation:               "outside_ok",
            date_for_remaining_time: countdown.latest_entry || (countdown.periods.map(&:last_day) << Date.today).max + 1,
            exit_date:               countdown.latest_entry || (countdown.periods.map(&:last_day) << Date.today).max + 1
          }
        end
      else
        if in_zone_on?(latest_entry: countdown.latest_entry)
          if time_spent == countdown.length_of_stay
            return quota_used_on(quota: Date.today)
          else
            return { situation: "overstay" }
          end
        else
          return quota_used_on(quota: countdown.periods.sort_by(&:last_day).last.last_day)
        end
      end
    end

    def quota_used_on(date: Date.today, future: nil, quota: nil)
      if countdown.latest_entry
        if countdown.latest_entry >= countdown.next_entry_from(date: date)
          return {
            situation:               "quota_#{future}used_can_enter",
            quota_day:               quota,
            next_entry_date:         date,
            date_for_remaining_time: countdown.latest_entry,
            exit_date:               countdown.latest_entry
          }
        else
          return {
            situation:               "quota_#{future}used_cannot_enter",
            quota_day:               quota,
            next_entry_date:         date,
            date_for_remaining_time: countdown.next_entry_from(date: date),
            exit_date:               countdown.next_entry_from(date: date)
          }
        end
      else
        return {
          situation:               "quota_#{future}used_no_entry",
          quota_day:               quota,
          next_entry_date:         date,
          date_for_remaining_time: countdown.next_entry_from(date: date),
          exit_date:               countdown.next_entry_from(date: date)
        }
      end
    end

    def in_zone_on?(date: Date.today, latest_entry: nil)
      countdown.entry_has_happened?(date: date, latest_entry: latest_entry) || countdown.periods.include?(date)
    end

    def one_future_period_too_long
      countdown.periods.sort_by(&:first_day).reject { |period| period.first_day < Date.today }.each do |period|
        if countdown.time_spent_on(date: period.last_day) > countdown.length_of_stay
          # plans won't work, one further period will overstay
          return {
            situation: "one_next_too_long",
            date_for_remaining_time:   period.first_day,
            exit_date: period.first_day
        }
        elsif countdown.time_spent_on(date: period.last_day) == countdown.length_of_stay
          return quota_used_on(quota: period.last_day, date: period.last_day + 1, future: "will_be_")
        end
      end
      return false
    end
  end
end
