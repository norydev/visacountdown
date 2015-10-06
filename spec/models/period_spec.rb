require 'rails_helper'

RSpec.describe Period, type: :model do

  it { should belong_to(:destination) }
  it { should validate_presence_of(:destination) }
  it { should validate_presence_of(:first_day) }
  it { should validate_presence_of(:last_day) }
  it { should validate_inclusion_of(:country).in_array(COUNTRIES).allow_blank }
  it { should validate_inclusion_of(:zone).in_array(ZONES) }

  it 'solves overlaping periods from same user and same country' do
    u = FactoryGirl.create :user, citizenship: "United States"
    d = FactoryGirl.create :destination, zone: "Schengen area", user: u
    FactoryGirl.create :period, destination: d, first_day: 40.days.ago, last_day: 20.days.ago, country: "Germany"
    FactoryGirl.create :period, destination: d, first_day: 30.days.ago, last_day: 10.days.ago, country: "Germany"

    expect(d.periods.size).to eq(1)
  end

  it 'keep periods as declared if not overlaping' do
    u = FactoryGirl.create :user, citizenship: "United States"
    d = FactoryGirl.create :destination, zone: "Schengen area", user: u
    FactoryGirl.create :period, destination: d, first_day: 40.days.ago, last_day: 20.days.ago, country: "Germany"
    FactoryGirl.create :period, destination: d, first_day: 19.days.ago, last_day: 10.days.ago, country: "Germany"

    expect(d.periods.size).to eq(2)
  end

end