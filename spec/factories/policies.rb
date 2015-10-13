FactoryGirl.define do
  factory :policy do
    citizenship   { COUNTRIES.sample }
    destination   { ZONES.sample }
  end

end
