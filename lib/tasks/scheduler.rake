task :erase_guest_user => :environment do
  #do something
  puts "destroying guest users"
  User.all.each do |u|
    if u.encrypted_password == "" && (Time.zone.now.to_date - u.updated_at.to_date).to_i >= 5
      u.destroy!
    end
  end
  puts "guest user removed"
end