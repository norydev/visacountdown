class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [ :twitter, :facebook ]

  validates_inclusion_of :citizenship, :in => COUNTRIES, :allow_blank => true
  validates_inclusion_of :location, :in => ZONES, :allow_blank => true

  has_many :destinations, dependent: :destroy

  def self.find_for_facebook_oauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.token = auth.credentials.token
      user.token_expiry = Time.at(auth.credentials.expires_at)
    end
  end

  def self.find_for_twitter_oauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = "#{auth.info.nickname}@visacountdown.com"
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.token = auth.credentials.token
    end
  end

  def to_s
    email
  end

  def entry_has_happened?(date = Time.zone.now.to_date, latest = self.latest_entry)
    if latest
      (date - latest).to_i >= 0
    else
      false
    end
  end

  def is_in_period?(date = Time.zone.now.to_date)
    user_periods = self.periods.where(zone: self.destination)

    is_in = false

    user_periods.each do |p|
      is_in = is_in || (p.first_day..p.last_day).include?(date)
    end
    is_in
  end

  def is_in_zone?(date = Time.zone.now.to_date, latest = self.latest_entry)
    self.entry_has_happened?(date, latest) || self.is_in_period?(date)
  end

  def current_period(date = Time.zone.now.to_date)
    user_periods = self.periods.where(zone: self.destination)
    period = nil
    user_periods.each do |p|
      period = p if (p.first_day..p.last_day).include?(date)
    end
    period
  end

  def time_spent(date = Time.zone.now.to_date, future = false, latest = self.latest_entry)
    nb_days = 0
    oldest_date = date - 179
    user_periods = self.periods.where(zone: self.destination)

    user_periods = remove_too_old(user_periods, oldest_date)
    user_periods = remove_future(user_periods, date)

    if latest && !future
      user_periods = remove_overlaps(user_periods, latest)
    end

    user_periods = user_periods.map do |period|
      (period.last_day - period.first_day).to_i + 1
    end
    nb_days += user_periods.reduce(:+) unless user_periods.empty?

    if self.entry_has_happened?(date, latest) && !future
      nb_days += (date - latest).to_i + 1
    end

    nb_days
  end

  def remaining_time(date = Time.zone.now.to_date, future = false, latest = self.latest_entry)
    rt = 0

    if future
      # start after entry, who is in the future?
      (date..(date + 89)).each do |day|
        rt += 1 if self.time_spent(day + 1, future, latest) + rt <= 90
      end
      rt -= 1
    else # elsif self.entry_has_happened?(date, latest)
      # start after entry, who is in the past
      (date..(latest + 89)).each do |day|
        rt += 1 if self.time_spent(day + 1, future, latest) <= 90
      end
    end
    rt
  end

  def next_entry(date = Time.zone.now.to_date)
    wt = 0
    (date..(date + 90)).each do |day|
      wt += 1 if self.time_spent(day, true) >= 90
    end
    date + wt
  end

  private

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

    def remove_overlaps(periods, latest = self.latest_entry)
      # remove period if started after latest entry
      periods = periods.reject do |p|
        (latest - p.first_day).to_i <= 0
      end

      # remove days that are after latest entry
      periods.map do |p|
        p.last_day = (latest - 1) if (latest - p.last_day).to_i <= 0
        p
      end
    end
end
