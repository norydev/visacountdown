class Destination < ActiveRecord::Base
  belongs_to :user
  has_many :periods, -> { order(last_day: :desc) }, dependent: :destroy

  validates_presence_of :zone

  def policy
    Policy.new(citizenship: user.citizenship, destination: zone)
  end

  def countdown
    Countdown.new(destination: self) if policy.length != policy.window
  end

  def to_s
    zone
  end

end
