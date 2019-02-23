require 'rails_helper'

RSpec.describe Policy, type: :model do
  describe 'a Schengen citizen goes to another Schengen country' do
    subject { Policy.new(citizenship: "Italy", destination: "Schengen area") }

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
    subject { Policy.new(citizenship: "United States", destination: "Schengen area") }

    it 'does not have freedom of movement' do
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
    subject { Policy.new(citizenship: "Bolivia", destination: "Schengen area") }

    it 'does not have freedom of movement' do
      expect(subject.freedom?).to be false
    end

    it 'visa need not supported' do
      expect(subject.need_visa?).to eq('no info')
    end

    it 'length of stay not supported' do
      expect(subject.length).to eq('no info')
    end

    it 'window of stay not supported' do
      expect(subject.window).to eq('no info')
    end
  end

  describe 'a Swiss citizen goes to Turkey' do
    subject { Policy.new(citizenship: "Switzerland", destination: "Turkey") }

    it 'does not have freedom of movement' do
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
    subject { Policy.new(citizenship: "United States", destination: "Turkey") }

    it 'does not have freedom of movement' do
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
    subject { Policy.new(citizenship: "Taiwan", destination: "Turkey") }

    it 'does not have freedom of movement' do
      expect(subject.freedom?).to be false
    end

    it 'visa need not supported' do
      expect(subject.need_visa?).to eq('no info')
    end

    it 'length of stay not supported' do
      expect(subject.length).to eq('no info')
    end

    it 'window of stay not supported' do
      expect(subject.window).to eq('no info')
    end
  end

  describe 'missing and not supported arguments' do

    it 'has no citizenship, destination Schengen' do
      p = Policy.new(destination: "Schengen")
      expect(p.freedom?).to match("Argument error: nothing found in DB")
    end

    it 'has no destination, citizenship Switzerland' do
      p = Policy.new(citizenship: "Switzerland")
      expect(p.need_visa?).to match("Argument error: nothing found in DB")
    end

    it 'has no destination, nor citizenship' do
      p = Policy.new
      expect(p.length).to match("Argument error: nothing found in DB")
    end

    it 'has Turkmenistan citizenship, goes to Turkey' do
      p = Policy.new(citizenship: "Turkmenistan")
      expect(p.window).to match("Argument error: nothing found in DB")
    end

    it 'has Switzerland citizenship, goes to China' do
      p = Policy.new(citizenship: "Switzerland", destination: "China")
      expect(p.freedom?).to match("Argument error: nothing found in DB")
    end

    it 'has Turkmenistan citizenship, goes to China' do
      p = Policy.new(citizenship: "Turkmenistan", destination: "China")
      expect(p.need_visa?).to match("Argument error: nothing found in DB")
    end
  end
end
