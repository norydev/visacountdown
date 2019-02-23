desc "Erase guest users who didn't make any modifications in the last 24h"
task erase_guest_user: :environment do
  puts "destroying guest users"

  User.where(encrypted_password: "", updated_at: 50.years.ago..1.day.ago).destroy_all

  puts "guest user removed"
end
