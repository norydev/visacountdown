class Destination < ActiveRecord::Base
  belongs_to :user
  has_many :periods, dependent: :destroy

  validates_presence_of :zone

  def policy
    Policy.new(citizenship: user.citizenship, destination: zone)
  end

  def countdown
    if policy.length != policy.window
      Countdown.new(destination: self)
    end
  end

end
