class Period < ActiveRecord::Base
  belongs_to :destination, required: true

  validates :first_day, :last_day, presence: true

  before_save :solve_overlaps

  private

    def all_periods_but_me
      self.destination.periods.where(zone: self.zone).where.not(id: id)
    end

    def solve_overlaps
      # Solve overlaps of periods in the same zone.
      # For Schengen, see Destination method to solve overlaps within a destination
      all_periods_but_me.each do |p|
        overlaps_with_previous = (p.first_day..p.last_day).overlaps?(self.first_day..self.last_day)

        if overlaps_with_previous
          self.first_day = [p.first_day, self.first_day].min
          self.last_day = [p.last_day, self.last_day].max
          p.destroy
        end
      end
    end
end
