class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :periods, dependent: :nullify #:destroy

  def to_s
    email
  end

  def is_in_turkey?
    if self.latest_entry
      (Time.zone.now.to_date - self.latest_entry).to_i >= 0
    else
      false
    end
  end

  def time_spent(day, future = false)
    nb_days = 0
    oldest_date = day - 179
    user_periods = self.periods

    user_periods = remove_too_old(user_periods, oldest_date)

    if self.latest_entry
      user_periods = remove_overlaps(user_periods)
    end

    user_periods = user_periods.map do |period|
      (period.last_day - period.first_day).to_i + 1
    end
    nb_days += user_periods.reduce(:+) unless user_periods.empty?

    if self.is_in_turkey? && !future
      nb_days += (day - self.latest_entry).to_i + 1
    end

    nb_days
  end

  def remaining_time(date = Time.zone.now.to_date, future = false)
    rt = 0
    latest = self.latest_entry

    if future
      (date..(date + 89)).each do |day|
        rt += 1 if time_spent(day, future) < 90
      end
    elsif self.is_in_turkey?
      (date..(latest + 89)).each do |day|
        rt += 1 if time_spent(day) < 90
      end
    else
      (latest..(latest + 89)).each do |day|
        rt += 1 if time_spent(day) + rt < 90
      end
    end
    rt
  end

  def latest_exit
    if self.is_in_turkey?
      (Time.zone.now.to_date + remaining_time).strftime("%B %d, %Y")
    else
      (self.latest_entry + remaining_time - 1).strftime("%B %d, %Y")
    end
  end

  def next_entry
    today = Time.zone.now.to_date
    rt = 0
    (today..(today + 90)).each do |day|
      rt += 1 if time_spent(day) >= 90
    end
    (today + rt).strftime("%B %d, %Y")
  end

  private

    def remove_too_old(periods, oldest_date)
      periods = periods.reject do |p|
        (p.last_day - oldest_date).to_i < 0
      end

      periods.map do |p|
        p.first_day = oldest_date if (p.first_day - oldest_date).to_i < 0
        p
      end
    end

    def remove_overlaps(periods)
      periods = periods.reject do |p|
        (self.latest_entry - p.first_day).to_i <= 0
      end

      periods.map do |p|
        p.last_day = (self.latest_entry - 1) if (self.latest_entry - p.last_day).to_i <= 0
        p
      end
    end
end
