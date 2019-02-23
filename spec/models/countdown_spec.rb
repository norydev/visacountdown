require 'rails_helper'

RSpec.describe Countdown, type: :model do
  before(:context) do
    u = FactoryBot.create :user, citizenship: "Switzerland"
    @d = FactoryBot.create :destination, user: u, zone: "Turkey"
  end

  describe 'Situation: inside_ok' do
    context 'no trip overlaping 180 days ago' do
      before(:context) do
        @d.update(latest_entry: 10.days.ago)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 50.days.ago, last_day: 40.days.ago
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 30.days.ago, last_day: 20.days.ago
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("inside_ok")
      end

      it 'returns the correct time spent' do
        expect(@countdown.time_spent).to eq(33)
      end

      it 'returns the correct remaining time' do
        expect(@countdown.remaining_time).to eq(57)
      end

      it 'returns the correct exit day' do
        expect(@countdown.exit_day).to eq(57.days.from_now.to_date)
      end
    end

    context '1 trip overlaping 180 days ago' do
      before(:context) do
        @d.update(latest_entry: 10.days.ago)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 185.days.ago, last_day: 105.days.ago
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("inside_ok")
      end

      it 'returns the correct time spent' do
        expect(@countdown.time_spent).to eq(86)
      end

      it 'returns the correct remaining time' do
        expect(@countdown.remaining_time).to eq(79)
      end

      it 'returns the correct exit day' do
        expect(@countdown.exit_day).to eq(79.days.from_now.to_date)
      end
    end

    context 'inside a period, latest entry after this period' do
      before(:context) do
        @d.update(latest_entry: 20.days.from_now)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 39.days.ago, last_day: 10.days.from_now
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("inside_ok")
      end

      it 'returns the correct time spent' do
        expect(@countdown.time_spent).to eq(40)
      end

      it 'returns the correct remaining time' do
        expect(@countdown.remaining_time).to eq(40)
      end

      it 'returns the correct exit day' do
        expect(@countdown.exit_day).to eq(59.days.from_now.to_date)
      end
    end

    context 'inside a period, no latest entry' do
      before(:context) do
        @d.update(latest_entry: nil)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 39.days.ago, last_day: 10.days.from_now
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("inside_ok")
      end

      it 'returns the correct time spent' do
        expect(@countdown.time_spent).to eq(40)
      end

      it 'returns the correct remaining time' do
        expect(@countdown.remaining_time).to eq(40)
      end

      it 'returns the correct exit day' do
        expect(@countdown.exit_day).to eq(50.days.from_now.to_date)
      end
    end
  end

  describe 'Situation: outside_ok' do
    context 'with latest entry in the future' do
      before(:context) do
        @d.update(latest_entry: 1.days.from_now)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 98.days.ago, last_day: 11.days.ago
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("outside_ok")
      end

      it 'returns the correct time spent' do
        expect(@countdown.time_spent).to eq(88)
      end

      it 'returns the correct remaining time' do
        expect(@countdown.remaining_time).to eq(2)
      end

      it 'returns the correct exit day' do
        expect(@countdown.exit_day).to eq(2.days.from_now.to_date)
      end
    end

    context 'without any latest entry' do
      before(:context) do
        @d.update(latest_entry: nil)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 50.days.ago, last_day: 11.days.ago
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("outside_ok")
      end

      it 'returns the correct time spent' do
        expect(@countdown.time_spent).to eq(40)
      end

      it 'returns the correct remaining time' do
        expect(@countdown.remaining_time).to eq(50)
      end

      it 'returns the correct exit day' do
        expect(@countdown.exit_day).to eq(50.days.from_now.to_date)
      end
    end
  end

  describe 'Situation: overstay' do
    context 'latest entry earlier than 90 days ago' do
      before(:context) do
        @d.update(latest_entry: 90.days.ago)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 120.days.ago, last_day: 100.days.ago
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("overstay")
      end

      it 'returns the correct time spent' do
        expect(@countdown.time_spent).to eq(112)
      end
    end
    context 'in the middle of a period longer than 90 days' do
      before(:context) do
        @d.update(latest_entry: nil)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 95.days.ago, last_day: 5.days.from_now
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("overstay")
      end

      it 'returns the correct time spent' do
        expect(@countdown.time_spent).to eq(96)
      end
    end
  end

  describe 'Situation: current_too_long' do
    context 'with latest entry in the future' do
      before(:context) do
        @d.update(latest_entry: 30.days.from_now)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 80.days.ago, last_day: 15.days.from_now
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("current_too_long")
      end

      it 'returns the correct remaining time' do
        expect(@countdown.remaining_time).to eq(9)
      end

      it 'returns the correct exit day' do
        expect(@countdown.exit_day).to eq(9.days.from_now.to_date)
      end
    end

    context 'without any latest entry' do
      before(:context) do
        @d.update(latest_entry: nil)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 80.days.ago, last_day: 15.days.from_now
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("current_too_long")
      end

      it 'returns the correct remaining time' do
        expect(@countdown.remaining_time).to eq(9)
      end

      it 'returns the correct exit day' do
        expect(@countdown.exit_day).to eq(9.days.from_now.to_date)
      end
    end
  end

  describe 'Situation: one_next_too_long' do
    context 'with latest entry in the future' do
      before(:context) do
        @d.update(latest_entry: 30.days.from_now)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 80.days.ago, last_day: 5.days.ago
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 5.days.from_now, last_day: 25.days.from_now
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("one_next_too_long")
      end

      it 'returns the correct remaining time' do
        expect(@countdown.remaining_time).to eq(14)
      end

      it 'returns the correct exit day' do
        expect(@countdown.exit_day).to eq(18.days.from_now.to_date)
      end
    end

    context 'without any latest entry' do
      before(:context) do
        @d.update(latest_entry: nil)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 80.days.ago, last_day: 5.days.ago
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 5.days.from_now, last_day: 25.days.from_now
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("one_next_too_long")
      end

      it 'returns the correct remaining time' do
        expect(@countdown.remaining_time).to eq(14)
      end

      it 'returns the correct exit day' do
        expect(@countdown.exit_day).to eq(18.days.from_now.to_date)
      end
    end
  end

  describe 'Situation: quota_will_be_used_can_enter' do
    context 'User in zone, in the middle of a period' do
      before(:context) do
        @d.update(latest_entry: 120.days.from_now)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 80.days.ago, last_day: 9.days.from_now
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("quota_will_be_used_can_enter")
      end

      it 'returns the correct day the quota is achieved' do
        expect(@countdown.quota_day).to eq(9.days.from_now.to_date)
      end

      it 'returns the correct next entry date' do
        expect(@countdown.next_entry).to eq(100.days.from_now.to_date)
      end

      it 'returns the correct remaining time' do
        expect(@countdown.remaining_time).to eq(90)
      end

      it 'returns the correct exit day' do
        expect(@countdown.exit_day).to eq(209.days.from_now.to_date)
      end
    end

    context 'User out of zone, one next period will use quota' do
      before(:context) do
        @d.update(latest_entry: 120.days.from_now)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 79.days.ago, last_day: 10.days.ago
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 5.days.from_now, last_day: 24.days.from_now
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("quota_will_be_used_can_enter")
      end

      it 'returns the correct day the quota is achieved' do
        expect(@countdown.quota_day).to eq(24.days.from_now.to_date)
      end

      it 'returns the correct next entry date' do
        expect(@countdown.next_entry).to eq(101.days.from_now.to_date)
      end

      it 'returns the correct remaining time' do
        expect(@countdown.remaining_time).to eq(90)
      end

      it 'returns the correct exit day' do
        expect(@countdown.exit_day).to eq(209.days.from_now.to_date)
      end
    end
  end

  describe 'Situation: quota_will_be_used_cannot_enter' do
    context 'User in zone, in the middle of a period' do
      before(:context) do
        @d.update(latest_entry: 60.days.from_now)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 80.days.ago, last_day: 9.days.from_now
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("quota_will_be_used_cannot_enter")
      end

      it 'returns the correct day the quota is achieved' do
        expect(@countdown.quota_day).to eq(9.days.from_now.to_date)
      end

      it 'returns the correct next entry date' do
        expect(@countdown.next_entry).to eq(100.days.from_now.to_date)
      end

      it 'returns the correct remaining time' do
        expect(@countdown.remaining_time).to eq(90)
      end

      it 'returns the correct exit day' do
        expect(@countdown.exit_day).to eq(189.days.from_now.to_date)
      end
    end

    context 'User out of zone, one next period will use quota' do
      before(:context) do
        @d.update(latest_entry: 60.days.from_now)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 89.days.ago, last_day: 20.days.ago
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 5.days.from_now, last_day: 24.days.from_now
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("quota_will_be_used_cannot_enter")
      end

      it 'returns the correct day the quota is achieved' do
        expect(@countdown.quota_day).to eq(24.days.from_now.to_date)
      end

      it 'returns the correct next entry date' do
        expect(@countdown.next_entry).to eq(91.days.from_now.to_date)
      end

      it 'returns the correct remaining time' do
        expect(@countdown.remaining_time).to eq(70)
      end

      it 'returns the correct exit day' do
        expect(@countdown.exit_day).to eq(160.days.from_now.to_date)
      end
    end
  end

  describe 'Situation: quota_will_be_used_no_entry' do
    context 'User in zone, in the middle of a period' do
      before(:context) do
        @d.update(latest_entry: nil)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 80.days.ago, last_day: 9.days.from_now
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("quota_will_be_used_no_entry")
      end

      it 'returns the correct day the quota is achieved' do
        expect(@countdown.quota_day).to eq(9.days.from_now.to_date)
      end

      it 'returns the correct next entry date' do
        expect(@countdown.next_entry).to eq(100.days.from_now.to_date)
      end

      it 'returns the correct remaining time' do
        expect(@countdown.remaining_time).to eq(90)
      end

      it 'returns the correct exit day' do
        expect(@countdown.exit_day).to eq(189.days.from_now.to_date)
      end
    end

    context 'User out of zone, one next period will use quota' do
      before(:context) do
        @d.update(latest_entry: nil)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 89.days.ago, last_day: 20.days.ago
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 5.days.from_now, last_day: 24.days.from_now
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("quota_will_be_used_no_entry")
      end

      it 'returns the correct day the quota is achieved' do
        expect(@countdown.quota_day).to eq(24.days.from_now.to_date)
      end

      it 'returns the correct next entry date' do
        expect(@countdown.next_entry).to eq(91.days.from_now.to_date)
      end

      it 'returns the correct remaining time' do
        expect(@countdown.remaining_time).to eq(70)
      end

      it 'returns the correct exit day' do
        expect(@countdown.exit_day).to eq(160.days.from_now.to_date)
      end
    end
  end

  describe 'Situation: quota_used_can_enter' do
    before(:context) do
      @d.update(latest_entry: 100.days.from_now)
      FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 109.days.ago, last_day: 20.days.ago
      @countdown = @d.reload.countdown
    end

    after(:context) do
      @d.periods.destroy_all
      @d.reload
    end

    it 'returns the correct situation' do
      expect(@countdown.situation).to eq("quota_used_can_enter")
    end

    it 'returns the correct day the quota is achieved' do
      expect(@countdown.quota_day).to eq(20.days.ago.to_date)
    end

    it 'returns the correct next entry date' do
      expect(@countdown.next_entry).to eq(71.days.from_now.to_date)
    end

    it 'returns the correct remaining time' do
      expect(@countdown.remaining_time).to eq(90)
    end

    it 'returns the correct exit day' do
      expect(@countdown.exit_day).to eq(189.days.from_now.to_date)
    end
  end

  describe 'Situation: quota_used_cannot_enter' do
    before(:context) do
      @d.update(latest_entry: 10.days.from_now)
      FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 109.days.ago, last_day: 20.days.ago
      @countdown = @d.reload.countdown
    end

    after(:context) do
      @d.periods.destroy_all
      @d.reload
    end

    it 'returns the correct situation' do
      expect(@countdown.situation).to eq("quota_used_cannot_enter")
    end

    it 'returns the correct day the quota is achieved' do
      expect(@countdown.quota_day).to eq(20.days.ago.to_date)
    end

    it 'returns the correct next entry date' do
      expect(@countdown.next_entry).to eq(71.days.from_now.to_date)
    end

    it 'returns the correct remaining time' do
      expect(@countdown.remaining_time).to eq(90)
    end

    it 'returns the correct exit day' do
      expect(@countdown.exit_day).to eq(160.days.from_now.to_date)
    end
  end

  describe 'Situation: quota_used_no_entry' do
    before(:context) do
      @d.update(latest_entry: nil)
      FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 109.days.ago, last_day: 20.days.ago
      @countdown = @d.reload.countdown
    end

    after(:context) do
      @d.periods.destroy_all
      @d.reload
    end

    it 'returns the correct situation' do
      expect(@countdown.situation).to eq("quota_used_no_entry")
    end

    it 'returns the correct day the quota is achieved' do
      expect(@countdown.quota_day).to eq(20.days.ago.to_date)
    end

    it 'returns the correct next entry date' do
      expect(@countdown.next_entry).to eq(71.days.from_now.to_date)
    end

    it 'returns the correct remaining time' do
      expect(@countdown.remaining_time).to eq(90)
    end

    it 'returns the correct exit day' do
      expect(@countdown.exit_day).to eq(160.days.from_now.to_date)
    end
  end

  describe 'Dumb User' do
    context 'latest entry in the middle of a period' do
      before(:context) do
        @d.update(latest_entry: 9.days.ago)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 84.days.ago, last_day: 25.days.ago
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 14.days.ago, last_day: 5.days.ago
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("inside_ok")
      end

      it 'returns the correct time spent' do
        expect(@countdown.time_spent).to eq(75)
      end

      it 'returns the correct remaining time' do
        expect(@countdown.remaining_time).to eq(15)
      end

      it 'returns the correct exit day' do
        expect(@countdown.exit_day).to eq(15.days.from_now.to_date)
      end
    end

    context 'latest entry before a full period' do
      before(:context) do
        @d.update(latest_entry: 9.days.ago)
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 84.days.ago, last_day: 25.days.ago
        FactoryBot.create :period, destination: @d, zone: @d.zone, first_day: 4.days.ago, last_day: 50.days.from_now
        @countdown = @d.reload.countdown
      end

      after(:context) do
        @d.periods.destroy_all
        @d.reload
      end

      it 'returns the correct situation' do
        expect(@countdown.situation).to eq("inside_ok")
      end

      it 'returns the correct time spent' do
        expect(@countdown.time_spent).to eq(70)
      end

      it 'returns the correct remaining time' do
        expect(@countdown.remaining_time).to eq(20)
      end

      it 'returns the correct exit day' do
        expect(@countdown.exit_day).to eq(20.days.from_now.to_date)
      end
    end
  end
end
