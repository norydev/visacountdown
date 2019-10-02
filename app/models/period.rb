class Period < ActiveRecord::Base
  belongs_to :destination, required: true
  has_one :user, through: :destination

  validates :destination, :first_day, :last_day, presence: true

  validates_inclusion_of :zone, in: ZONES
  validates_inclusion_of :country, in: COUNTRIES, allow_blank: true

  before_save :solve_overlaps

  private

    def all_periods_but_me
      Period.where(destination: destination).where(zone: zone).where.not(id: id)
    end

    def solve_overlaps
      # Solve overlaps of periods in the same zone.
      all_periods_but_me.each do |period|
        overlaps_with_previous = (period.first_day..period.last_day).overlaps?(self.first_day..self.last_day)

        if overlaps_with_previous
          self.first_day = [period.first_day, self.first_day].min
          self.last_day = [period.last_day, self.last_day].max
          period.destroy
        end
      end
    end
end

# == Schema Information
#
# Table name: periods
#
#  id             :bigint(8)        not null, primary key
#  country        :string
#  first_day      :date             not null
#  last_day       :date             not null
#  zone           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  destination_id :integer
#
# Indexes
#
#  index_periods_on_destination_id  (destination_id)
#
# Foreign Keys
#
#  fk_rails_...  (destination_id => destinations.id)
#
