class Destination < ActiveRecord::Base
  belongs_to :user
  has_many :periods, dependent: :destroy

  validates_presence_of :zone

  def policy
    Policy.new(citizenship: user.citizenship, destination: zone)
  end

  private

    # solve overlaps in same zone (only usefull for Schengen actually)
    def solve_overlaps
    end
end
