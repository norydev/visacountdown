class Destination < ActiveRecord::Base
  belongs_to :user
  has_many :periods, dependent: :destroy

  validates_presence_of :country

  def zone
    if schengen.include?(country)
      "Schengen area"
    else
      country
    end
  end

  def policy
    Policy.new(user.citizenship, zone)
  end

  private
    def schengen
      %w(Austria Belgium Czech\ republic Denmark Estonia Finland France Germany Greece Hungary Iceland Italy Latvia Lithuania Luxembourg Malta Netherlands Norway Poland Portugal Slovakia Slovenia Spain Sweden Switzerland Liechtenstein)
    end
end
