FactoryGirl.define do
  factory :destination do
    zone          "Schengen area"
    association   :user
  end

end
