class Countdown

  def initialize(destination: nil)
    @latest_entry = destination.latest_entry
    @periods = destination.periods
    @length = destination.policy.length
    @window = destination.policy.window
  end

  def time_spent
    get_time_spent(latest_entry: @latest_entry)
  end

  def remaining_time
    n = get_remaining_time(date: status[:rt_date], latest_entry: status[:rt_latest])
    n += 1 unless entry_has_happened?(date: status[:rt_date], latest_entry: status[:rt_latest])
    n
  end

  def exit_day
    d = get_exit_day(date: status[:exit_date])
    d -= 1 unless entry_has_happened?(date: status[:rt_date], latest_entry: status[:rt_latest])
    d
  end

  def next_entry
    get_next_entry(date: status[:ne_date])
  end

  def quota_day
    status[:quota_day]
  end

  def situation
    status[:situation]
  end

  private

    # DEFINE STATUS
    def status
      time_spent = get_time_spent(latest_entry: @latest_entry)
      if time_spent < @length
        if entry_has_happened?(latest_entry: @latest_entry)
          return { situation: "inside_ok", rt_date: Date.current, rt_latest: @latest_entry, exit_date: Date.current }
        elsif user_in_period?
          if get_time_spent(date: user_current_period.last_day) > @length
            return { situation: "current_too_long", rt_date: Date.current, rt_latest: user_current_period.first_day, exit_date: Date.current }
          elsif get_time_spent(date: user_current_period.last_day) == @length
            return quota_used(date: user_current_period.last_day + 1, future: "will_be_", quota: user_current_period.last_day)
          else
            # check if one next is too long otherwise inside ok
            return one_period_too_long || { situation: "inside_ok", rt_date: @latest_entry || user_current_period.last_day + 1, exit_date: @latest_entry || user_current_period.last_day + 1 }
          end
        else
          # check if one next is too long otherwise outside ok
          return one_period_too_long || { situation: "outside_ok", rt_date: @latest_entry || Date.current + 1, exit_date: @latest_entry || Date.current + 1 }
        end
      elsif time_spent == @length
        return quota_used(quota: Date.current)
      else
        if user_in_zone?(latest_entry: @latest_entry)
          return { situation: "overstay" }
        else
          return quota_used(quota: @periods.order(last_day: :desc).first.last_day)
        end
      end
    end

    def one_period_too_long
      @periods.order(:first_day).reject { |p| p.first_day < Date.current }.each do |p|
        if get_time_spent(date: p.last_day) > @length
          # plans won't work, one further period will overstay
          return { situation: "one_next_too_long", rt_date: p.first_day, exit_date: p.first_day }
        elsif get_time_spent(date: p.last_day) == @length
          return quota_used(quota: p.last_day, date: p.last_day + 1, future: "will_be_")
        end
      end
      return nil
    end

    def quota_used(date: Date.current, future: nil, quota: nil)
      if @latest_entry
        if @latest_entry >= get_next_entry(date: date)
          return { situation: "quota_#{future}used_can_enter", quota_day: quota, ne_date: date, rt_date: @latest_entry, exit_date: @latest_entry }
        else
          return { situation: "quota_#{future}used_cannot_enter", quota_day: quota, ne_date: date, rt_date: get_next_entry(date: date), exit_date: get_next_entry(date: date) }
        end
      else
        return { situation: "quota_#{future}used_no_entry", quota_day: quota, ne_date: date, rt_date: get_next_entry(date: date), exit_date: get_next_entry(date: date) }
      end
    end
    # END DEFINE STATUS

    def get_time_spent(date: Date.current, latest_entry: nil)
      nb_days = 0
      oldest_date = date - (@window - 1)

      user_periods = remove_too_old(@periods.clone, oldest_date)
      user_periods = remove_future(user_periods, date)

      user_periods = remove_overlaps(user_periods, latest_entry) if latest_entry

      if user_periods.present?
        user_periods = user_periods.map do |period|
          (period.last_day - period.first_day).to_i + 1
        end
        nb_days += user_periods.reduce(:+)
      end

      if latest_entry && entry_has_happened?(date: date, latest_entry: latest_entry)
        nb_days += (date - latest_entry).to_i + 1
      end
      nb_days
    end

    def get_remaining_time(date: Date.current, latest_entry: nil)
      rt = 0
      entry = latest_entry || date

      (date + 1..(entry + (@length - 1))).each do |day|
        rt += 1 if get_time_spent(date: day, latest_entry: entry) <= @length
      end
      rt
    end

    def get_exit_day(date: Date.current)
      date + remaining_time
    end

    def get_next_entry(date: Date.current)
      wt = 0
      periods = @periods.clone

      (date..(date + @length)).each do |day|
        wt += 1 unless periods.select { |p| (p.first_day..p.last_day).include?(day - @window) }.present?
      end
      date + wt
    end

    def user_in_period?(date: Date.current)
      @periods.clone.select { |p| (p.first_day..p.last_day).include?(date) }.present?
    end

    def user_current_period(date: Date.current)
      @periods.clone.select { |p| (p.first_day..p.last_day).include?(date) }.first
    end

    def user_in_zone?(date: Date.current, latest_entry: nil)
      entry_has_happened?(date: date, latest_entry: latest_entry) || user_in_period?(date: date)
    end

    def entry_has_happened?(date: Date.current, latest_entry: nil)
      latest_entry && latest_entry < date
    end

    def remove_too_old(periods, oldest_date)
      # remove if period is entirely before oldest date
      periods = periods.reject do |p|
        p.last_day < oldest_date
      end

      # remove all the days that are before the oldest day
      periods.map do |p|
        p.first_day = oldest_date if p.first_day < oldest_date
        p
      end
    end

    def remove_future(periods, day)
      # remove period if it is totally in the future
      periods = periods.reject do |p|
        p.first_day > day
      end

      # remove days of the period that are in the future
      periods.map do |p|
        p.last_day = day if p.last_day > day
        p
      end
    end

    def remove_overlaps(periods, latest_entry)
      # remove period if started after latest entry
      periods = periods.reject do |p|
        latest_entry <= p.first_day
      end

      # remove days that are after latest entry
      periods.map do |p|
        p.last_day = (latest_entry - 1) if latest_entry <= p.last_day
        p
      end
    end
end