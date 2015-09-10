class Destination < ActiveRecord::Base
  belongs_to :user
  has_many :periods, dependent: :destroy

  validates_presence_of :zone

  def policy
    Policy.new(user.citizenship, zone)
  end
end
