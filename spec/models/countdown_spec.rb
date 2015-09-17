require 'rails_helper'

RSpec.describe Countdown, type: :model do

  describe 'Smart User' do

    before(:context) do
      u = FactoryGirl.create :user, citizenship: "Switzerland"
      @d = FactoryGirl.create :destination, user: u, zone: "Turkey", latest_entry: 10.days.ago
    end

    context 'With 2 short trips in the past 90 days, entered 10 days ago' do
      before(:context) do
        p1 = FactoryGirl.create :period, destination: @d, zone: @d.zone, first_day: 50.days.ago, last_day: 40.days.ago
        p2 = FactoryGirl.create :period, destination: @d, zone: @d.zone, first_day: 30.days.ago, last_day: 20.days.ago
        @countdown = @d.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'should return the correct time spent' do
        expect(@countdown.time_spent).to be(33)
      end

      it 'should return the correct remaining time' do
        expect(@countdown.remaining_time).to be(57)
      end

      it 'should return the correct exit day' do
        expect(@countdown.exit_day.to_s).to match(Date.parse(57.days.from_now.to_s).to_s)
      end
    end

    context 'With 1 trip overlaping 180 days ago, entered 10 days ago' do
      before(:context) do
        p1 = FactoryGirl.create :period, destination: @d, zone: @d.zone, first_day: 185.days.ago, last_day: 105.days.ago
        @countdown = @d.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'should return the correct time spent' do
        expect(@countdown.time_spent).to be(86)
      end

      it 'should return the correct remaining time' do
        expect(@countdown.remaining_time).to be(79)
      end

      it 'should return the correct exit day' do
        expect(@countdown.exit_day.to_s).to match(Date.parse(79.days.from_now.to_s).to_s)
      end
    end
  end

  describe 'Dumb User' do
    it 'should return the total number of days'
  end

end
