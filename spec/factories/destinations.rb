FactoryBot.define do
  factory :destination do
    zone          { ZONES.sample }
    latest_entry  { [rand(20).days.ago, nil].sample }
    association   :user
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
