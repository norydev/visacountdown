class Countdown

  def initialize(destination: nil)
    @destination = destination
  end

  def time_spent
    get_time_spent(latest_entry: @destination.latest_entry)
  end

  def remaining_time
    get_remaining_time(date: status[:rt_date], latest_entry: status[:rt_latest])
  end

  def exit_day
    get_exit_day(date: status[:exit_date])
  end

  def next_entry
    get_next_entry(date: status[:ne_date])
  end

  def situation
    status[:situation]
  end

  private

    def status
      if get_time_spent(latest_entry: @destination.latest_entry) < 90
        if entry_has_happened?(latest_entry: @destination.latest_entry)
          return { situation: "inside_ok", rt_date: Date.current, rt_latest: @destination.latest_entry, exit_date: Date.current}
        elsif user_in_period?
          if get_time_spent(date: user_current_period.last_day) > 90
            return { situation: "current_too_long", rt_date: Date.current, rt_latest: user_current_period.first_day, exit_date: Date.current}
          elsif get_time_spent(date: user_current_period.last_day) == 90
            # fix: DRY
            if @destination.latest_entry
              if @destination.latest_entry >= get_next_entry(date: user_current_period.last_day + 1)
                return { situation: "quota_will_be_used_can_enter", ne_date: user_current_period.last_day + 1, rt_date: @destination.latest_entry, exit_date: @destination.latest_entry }
              else
                return { situation: "quota_will_be_used_cannot_enter", ne_date: user_current_period.last_day + 1, rt_date: get_next_entry(date: user_current_period.last_day + 1), exit_date: get_next_entry(date: user_current_period.last_day + 1) }
              end
            else
              return { situation: "quota_will_be_used_no_entry", ne_date: user_current_period.last_day + 1, rt_date: get_next_entry(date: user_current_period.last_day + 1), exit_date: get_next_entry(date: user_current_period.last_day + 1) }
            end
          else
            # fix: DRY
            # check if one next is too long
            @destination.periods.order(:first_day).each do |p|
              next if p.first_day < Date.current
              if get_time_spent(date: p.last_day) > 90
                #plans won't work, one further period will overstay
                return { situation: "one_next_too_long", rt_date: p.first_day, exit_date: p.first_day }
              elsif get_time_spent(date: p.last_day) == 90
                # fix: DRY
                if @destination.latest_entry
                  if @destination.latest_entry >= get_next_entry(date: p.last_day + 1)
                    return { situation: "quota_will_be_used_can_enter", ne_date: p.last_day + 1, rt_date: @destination.latest_entry, exit_date: @destination.latest_entry }
                  else
                    return { situation: "quota_will_be_used_cannot_enter", ne_date: p.last_day + 1, rt_date: get_next_entry(date: p.last_day + 1), exit_date: get_next_entry(date: p.last_day + 1) }
                  end
                else
                  return { situation: "quota_will_be_used_no_entry", ne_date: p.last_day + 1, rt_date: get_next_entry(date: p.last_day + 1), exit_date: get_next_entry(date: p.last_day + 1) }
                end
              end
            end
            # otherwise inside ok
            return { situation: "inside_ok", rt_date: @destination.latest_entry || user_current_period.last_day + 1, exit_date: @destination.latest_entry || user_current_period.last_day + 1}
          end
        else
          # fix: DRY
          # check if one next is too long
          @destination.periods.order(:first_day).each do |p|
            next if p.first_day < Date.current
            if get_time_spent(date: p.last_day) > 90
              #plans won't work, one further period will overstay
              return { situation: "one_next_too_long", rt_date: p.first_day, exit_date: p.first_day }
            elsif get_time_spent(date: p.last_day) == 90
              # fix: DRY
              if @destination.latest_entry
                if @destination.latest_entry >= get_next_entry(date: p.last_day + 1)
                  return { situation: "quota_will_be_used_can_enter", ne_date: p.last_day + 1, rt_date: @destination.latest_entry, exit_date: @destination.latest_entry }
                else
                  return { situation: "quota_will_be_used_cannot_enter", ne_date: p.last_day + 1, rt_date: get_next_entry(date: p.last_day + 1), exit_date: get_next_entry(date: p.last_day + 1) }
                end
              else
                return { situation: "quota_will_be_used_no_entry", ne_date: p.last_day + 1, rt_date: get_next_entry(date: p.last_day + 1), exit_date: get_next_entry(date: p.last_day + 1) }
              end
            end
          end
          # otherwise outisde ok
          return { situation: "outside_ok", rt_date: @destination.latest_entry || Date.current + 1, exit_date: @destination.latest_entry || Date.current + 1 }
        end
      else
        if user_in_zone?(latest_entry: @destination.latest_entry)
          return { situation: "overstay" }
        else
          if @destination.latest_entry
            if @destination.latest_entry >= get_next_entry(date: Date.current)
              return { situation: "quota_used_can_enter", ne_date: Date.current, rt_date: @destination.latest_entry, exit_date: @destination.latest_entry }
            else
              return { situation: "quota_used_cannot_enter", ne_date: Date.current, rt_date: get_next_entry(date: Date.current), exit_date: get_next_entry(date: Date.current) }
            end
          else
            return { situation: "quota_used_no_entry", ne_date: Date.current, rt_date: get_next_entry(date: Date.current), exit_date: get_next_entry(date: Date.current) }
          end
        end
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

      if latest_entry && entry_has_happened?(date: date, latest_entry: latest_entry)
        nb_days += (date - latest_entry).to_i + 1
      end
      nb_days
    end

    def get_remaining_time(date: Date.current, latest_entry: nil)
      rt = 0
      entry = latest_entry || date

      (date..(entry + 89)).each do |day|
        rt += 1 if get_time_spent(date: day + 1, latest_entry: entry) <= 90
      end
      rt
    end

    def get_exit_day(date: Date.current)
      date + remaining_time
    end

    def get_next_entry(date: Date.current)
      wt = 0
      (date..(date + 90)).each do |day|
        wt += 1 if get_time_spent(date: day) >= 90
      end
      date + wt
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

    def user_in_zone?(date: Date.current, latest_entry: nil)
      entry_has_happened?(date: date, latest_entry: latest_entry) || user_in_period?(date: date)
    end

    def entry_has_happened?(date: Date.current, latest_entry: nil)
      latest_entry && latest_entry < date
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