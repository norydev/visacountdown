FactoryBot.define do
  d = rand(180)
  factory :period do
    first_day    { d.days.ago }
    last_day     { (d + 10).days.ago }
    zone         { ZONES.sample }
    association  :destination
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
