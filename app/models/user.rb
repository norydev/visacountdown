class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :periods, dependent: :destroy

  def to_s
    email
  end

  def time_spent(day)
    nb_days = 0
    oldest_date = day - 179
    user_periods = self.periods

    user_periods = remove_too_old(user_periods, oldest_date)

    user_periods = user_periods.map do |period|
      (period.last_day - period.first_day).to_i + 1
    end
    nb_days += user_periods.reduce(:+) unless user_periods.empty?

    if self.is_in_turkey
      nb_days += (day - self.latest_entry).to_i + 1
    end

    nb_days
  end

  def remaining_time
    rt = 0
    latest = self.latest_entry
    today = Time.zone.now.to_date

    if self.is_in_turkey
      (today..(latest + 89)).each do |day|
        rt += 1 if time_spent(day) < 90
      end
    end
    rt
  end

  def latest_exit
    (Time.zone.now.to_date + remaining_time).strftime("%B %d, %Y")
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
end
