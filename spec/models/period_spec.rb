require 'rails_helper'

RSpec.describe Period, type: :model do

  it { should belong_to(:destination).required }
  it { should validate_presence_of(:destination) }
  it { should validate_presence_of(:first_day) }
  it { should validate_presence_of(:last_day) }
  it { should validate_inclusion_of(:country).in_array(COUNTRIES).allow_blank }
  it { should validate_inclusion_of(:zone).in_array(ZONES) }

  it 'solves overlaping periods from same user and same country' do
    u = FactoryBot.create :user, citizenship: "United States"
    d = FactoryBot.create :destination, zone: "Schengen area", user: u
    FactoryBot.create :period, destination: d, first_day: 40.days.ago, last_day: 20.days.ago, country: "Germany"
    FactoryBot.create :period, destination: d, first_day: 30.days.ago, last_day: 10.days.ago, country: "Germany"

    expect(d.periods.size).to eq(1)
  end

  it 'keep periods as declared if not overlaping' do
    u = FactoryBot.create :user, citizenship: "United States"
    d = FactoryBot.create :destination, zone: "Schengen area", user: u
    FactoryBot.create :period, destination: d, first_day: 40.days.ago, last_day: 20.days.ago, country: "Germany"
    FactoryBot.create :period, destination: d, first_day: 19.days.ago, last_day: 10.days.ago, country: "Germany"

    expect(d.periods.size).to eq(2)
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
