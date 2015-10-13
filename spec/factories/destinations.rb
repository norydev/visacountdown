FactoryGirl.define do
  factory :destination do
    zone          { ZONES.sample }
    latest_entry  { [rand(20).days.ago, nil].sample }
    association   :user
  end

end
