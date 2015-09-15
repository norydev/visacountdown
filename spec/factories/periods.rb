FactoryGirl.define do
  factory :period do
    first_day   40.days.ago
    last_day    20.days.ago
    country     "Germany"
    association :destination
  end

end
