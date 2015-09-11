require 'rails_helper'

RSpec.describe Policy, type: :model do
  describe 'a Schengen citizen goes to another Schengen country' do

    subject { Policy.new("Italy", "Schengen area") }

    it 'has freedom of movement' do
      expect(subject.freedom?).to be true
    end

    it 'does not need a visa' do
      expect(subject.need_visa?).to be false
    end

    it 'should be able to stay as long as he wants' do
      expect(subject.length).to eq(0)
    end

    it 'does not have any window of stay' do
      expect(subject.window).to eq(0)
    end
  end

  describe 'a citizen from United States goes to Schengen' do

    subject { Policy.new("United States", "Schengen area") }

    it 'dows not have freedom of movement' do
      expect(subject.freedom?).to be false
    end

    it 'does not need a visa' do
      expect(subject.need_visa?).to be false
    end

    it 'can stay 90 days' do
      expect(subject.length).to eq(90)
    end

    it 'has a window of stay of 180 days' do
      expect(subject.window).to eq(180)
    end
  end

  describe 'a citizen from Bolivia goes to Schengen' do

    subject { Policy.new("Bolivia", "Schengen area") }

    it 'dows not have freedom of movement' do
      expect(subject.freedom?).to be false
    end

    it 'visa need not supported' do
      expect(subject.need_visa?).to eq('error')
    end

    it 'length of stay not supported' do
      expect(subject.length).to eq('error')
    end

    it 'window of stay not supported' do
      expect(subject.window).to eq('error')
    end
  end

  describe 'a Swiss citizen goes to Turkey' do

    subject { Policy.new("Switzerland", "Turkey") }

    it 'dows not have freedom of movement' do
      expect(subject.freedom?).to be false
    end

    it 'does not need a visa' do
      expect(subject.need_visa?).to be false
    end

    it 'can stay 90 days' do
      expect(subject.length).to eq(90)
    end

    it 'has a window of stay of 180 days' do
      expect(subject.window).to eq(180)
    end
  end

  describe 'a citizen from United States goes to Turkey' do

    subject { Policy.new("United States", "Turkey") }

    it 'dows not have freedom of movement' do
      expect(subject.freedom?).to be false
    end

    it 'needs a visa' do
      expect(subject.need_visa?).to be true
    end

    it 'can stay 90 days' do
      expect(subject.length).to eq(90)
    end

    it 'has a window of stay of 180 days' do
      expect(subject.window).to eq(180)
    end
  end

  describe 'a citizen from Taiwan goes to Turkey' do

    subject { Policy.new("Taiwan", "Turkey") }

    it 'dows not have freedom of movement' do
      expect(subject.freedom?).to be false
    end

    it 'visa need not supported' do
      expect(subject.need_visa?).to eq('error')
    end

    it 'length of stay not supported' do
      expect(subject.length).to eq('error')
    end

    it 'window of stay not supported' do
      expect(subject.window).to eq('error')
    end
  end
end
