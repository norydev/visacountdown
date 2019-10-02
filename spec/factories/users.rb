FactoryBot.define do
  factory :user do
    email                 { Faker::Internet.email }
    password              { "12345678" }
    password_confirmation { "12345678" }
    citizenship           { COUNTRIES.sample }
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  admin                  :boolean          default(FALSE), not null
#  citizenship            :string           default("None"), not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  token                  :string
#  token_expiry           :datetime
#  uid                    :string
#  created_at             :datetime
#  updated_at             :datetime
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
