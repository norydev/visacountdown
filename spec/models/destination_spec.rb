require 'rails_helper'

RSpec.describe Destination, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:periods).dependent(:destroy) }
  it { should validate_presence_of(:zone) }

  it 'responds to policy with a Policy object' do
    user = FactoryBot.build :user, citizenship: "Switzerland"
    destination = FactoryBot.build :destination, user: user, zone: "Turkey"
    expect(destination.policy).to be_an_instance_of(Policy)
  end

  it 'responds to policy with the correct Policy' do
    user = FactoryBot.build :user, citizenship: "Switzerland"
    destination = FactoryBot.build :destination, user: user, zone: "Turkey"
    expect(destination.policy).to have_attributes(destination: "Turkey", citizenship: "Switzerland")
  end
end

# == Schema Information
#
# Table name: destinations
#
#  id           :bigint(8)        not null, primary key
#  latest_entry :date
#  zone         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#
# Indexes
#
#  index_destinations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
