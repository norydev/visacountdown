class Period < ActiveRecord::Base
  belongs_to :user

  validates :first_day, :last_day, presence: true

  before_save :solve_overlaps

  private

    def solve_overlaps
      self.user.periods.each do |p|
        next if self == p

        overlaps_with_previous = (p.first_day..p.last_day).overlaps?(self.first_day..self.last_day)

        if overlaps_with_previous
          self.first_day = [p.first_day, self.first_day].min
          self.last_day = [p.last_day, self.last_day].max
          p.destroy
        end
      end
    end
end
