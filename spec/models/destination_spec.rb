require 'rails_helper'

RSpec.describe Destination, type: :model do

  it { should belong_to(:user) }
  it { should have_many(:periods).dependent(:destroy)}
  it { should validate_presence_of(:zone) }

  it 'responds to policy with a Policy object' do
    u = FactoryGirl.build :user, citizenship: "Switzerland"
    d = FactoryGirl.build :destination, user: u, zone: "Turkey"
    expect(d.policy).to be_an_instance_of(Policy)
  end

  it 'responds to policy with the correct Policy' do
    u = FactoryGirl.build :user, citizenship: "Switzerland"
    d = FactoryGirl.build :destination, user: u, zone: "Turkey"
    expect(d.policy.destination).to match("Turkey")
    expect(d.policy.citizenship).to match("Switzerland")
  end
end
