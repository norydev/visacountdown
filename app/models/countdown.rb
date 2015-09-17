class Countdown

  def initialize(destination: nil)
    @destination = destination
  end

  def time_spent
    get_time_spent(latest_entry:  @destination.latest_entry)
  end

  def remaining_time
    get_remaining_time(latest_entry:  @destination.latest_entry)
  end

  def exit_day
    Date.current + remaining_time
  end

  def next_entry(date: Date.current)
    wt = 0
    (date..(date + 90)).each do |day|
      wt += 1 if get_time_spent(day) >= 90
    end
    date + wt
  end

  private

    def status
      if get_time_spent(latest_entry: @destination.latest_entry) < 90
        if entry_has_happened?(latest_entry: @destination.latest_entry)
          situation = "inside_ok"
        elsif user_in_period? && get_time_spent(date: user_current_period.last_day) > 90
          situation = "current_too_long"
        elsif user_in_period? && get_time_spent(date: user_current_period.last_day) == 90
          situation = "quota_will_be_used"
        else
          period_found = false
          @destination.periods.order(:first_day).each do |p|
            next if p.first_day < Date.current
            if get_time_spent(date: p.last_day) > 90
              #plans won't work, one further period will overstay
              period_found = true
              situation = "one_next_too_long"

              break
            elsif get_time_spent(date: p.last_day) == 90
              period_found = true

              if @destination.latest_entry
                if @destination.latest_entry >= next_entry(user_current_period.last_day + 1)
                  situation = "quota_will_be_used_can_enter"
                else
                  situation = "quota_will_be_used_cannot_enter"
                end
              else
                situation = "quota_will_be_used_no_entry"
              end
            end
          end
          unless period_found
            #plan will work
            situation = "outside_ok"
          end
        end
      else
        if entry_has_happened?(latest_entry: @destination.latest_entry)
          situation = "overstay"
        else
          situation = "quota_used"
        end
      end
    end

    def user_in_period?(date: Date.current)
      user_periods = @destination.periods.clone

      is_in = false

      user_periods.each do |p|
        is_in = is_in || (p.first_day..p.last_day).include?(date)
      end
      is_in
    end

    def user_current_period(date: Date.current)
      user_periods = @destination.periods.clone
      period = nil
      user_periods.each do |p|
        period = p if (p.first_day..p.last_day).include?(date)
      end
      period
    end

    def is_in_zone?(date: Date.current, latest_entry: nil)
      entry_has_happened?(date, latest_entry) || user_in_period?(date)
    end

    def entry_has_happened?(date: Date.current, latest_entry: nil)
      if latest_entry
        latest_entry < date
      else
        nil
      end
    end

    def get_time_spent(date: Date.current, latest_entry: nil)
      nb_days = 0

      oldest_date = date - 179
      user_periods = @destination.periods.clone

      user_periods = remove_too_old(user_periods, oldest_date)
      user_periods = remove_future(user_periods, date)

      user_periods = remove_overlaps(user_periods, latest_entry) if latest_entry

      if user_periods.present?
        user_periods = user_periods.map do |period|
          (period.last_day - period.first_day).to_i + 1
        end
        nb_days += user_periods.reduce(:+)
      end

      if latest_entry && entry_has_happened?(date, latest_entry)
        nb_days += (date - latest_entry).to_i + 1
      end
      nb_days
    end

    def get_remaining_time(date: Date.current, latest_entry: nil)
      rt = 0

      if latest_entry
        # start after entry, who is in the past
        (date..(latest_entry + 89)).each do |day|
          rt += 1 if get_time_spent(day + 1, latest_entry) <= 90
        end
      else
        (date..(date + 89)).each do |day|
          rt += 1 if get_time_spent(day + 1) + rt <= 90
        end
        rt -= 1
      end
      rt
    end

    def remove_too_old(periods, oldest_date)
      # remove if period is entirely before oldest date
      periods = periods.reject do |p|
        (p.last_day - oldest_date).to_i < 0
      end

      # remove all the days that are before the oldest day
      periods.map do |p|
        p.first_day = oldest_date if (p.first_day - oldest_date).to_i < 0
        p
      end
    end

    def remove_future(periods, day)
      # remove period if it is totally in the future
      periods = periods.reject do |p|
        (p.first_day - day).to_i > 0
      end

      # remove days of the period that are in the future
      periods.map do |p|
        p.last_day = day if (p.last_day - day).to_i > 0
        p
      end
    end

    def remove_overlaps(periods, latest_entry)
      # remove period if started after latest entry
      periods = periods.reject do |p|
        (latest_entry - p.first_day).to_i <= 0
      end

      # remove days that are after latest entry
      periods.map do |p|
        p.last_day = (latest_entry - 1) if (latest_entry - p.last_day).to_i <= 0
        p
      end
    end
end