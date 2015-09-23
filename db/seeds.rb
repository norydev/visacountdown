# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.new
admin.email = "superadmin@yopmail.com"
admin.password = "superadmin"
admin.password_confirmation = "superadmin"
admin.admin = true
admin.save

10.times do
  u = User.new
  u.email = "#{Faker::Internet.user_name}@yopmail.com"
  u.password = "12345678"
  u.password_confirmation = "12345678"
  u.citizenship = COUNTRIES.sample
  u.save
end

User.all.each do |u|
  d = Destination.new
  d.user = u
  d.zone = ZONES.sample
  d.latest_entry = [rand(20).days.ago, nil].sample
  d.save
end

Destination.all.each do |d|
  3.times do
    p = Period.new
    start = Faker::Date.backward(220)
    p.first_day = start
    p.last_day = start + 20
    p.zone = d.zone
    p.destination = d
    p.save
  end
end