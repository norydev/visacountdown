FactoryGirl.define do
  factory :user do
    email                 { Faker::Internet.email }
    password              "12345678"
    password_confirmation "12345678"
    citizenship           "United States"
    location              "Schengen area"
    latest_entry          10.days.ago
  end
end