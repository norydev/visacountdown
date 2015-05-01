class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :periods

  def to_s
    email
  end

  def time_spent(today)
    too_old = today - 179
    user_periods = self.periods

    user_periods = remove_too_old(user_periods, too_old)

    user_periods = user_periods.map do |period|
      (period.last_day - period.first_day).to_i + 1
    end
    user_periods.reduce(:+)
  end

  def remaining_time
    rt = 89 - self.time_spent(Date.today)
    latest = self.periods.order(first_day: :desc).first

    (Date.today..(latest.first_day + 89)).each do |day|
      rt = rt + 1 if time_spent(day) < 90
    end

    rt
  end

  private

    def remove_too_old(periods, oldest_date)
      periods = periods.reject do |p|
        (p.last_day - oldest_date).to_i <= 0
      end

      periods.map do |p|
        p.first_day = oldest_date if (p.first_day - oldest_date).to_i <= 0
        p
      end
    end

end
