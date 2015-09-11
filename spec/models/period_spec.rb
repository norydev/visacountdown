require 'rails_helper'

RSpec.describe Period, type: :model do

  it { should belong_to(:destination) }
  it { should validate_presence_of(:destination) }
  it { should validate_presence_of(:first_day) }
  it { should validate_presence_of(:last_day) }

  it 'solves overlaping periods from same user and same country'
  it 'solves overlaping periods before saving'

end