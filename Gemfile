source "https://rubygems.org"

ruby "2.6.5"

gem "rails", "6.0.0"
gem "pg"
gem "figaro"
gem "simple_form"
gem "high_voltage"
gem "devise"

gem "jquery-rails"
gem "jquery-ui-rails"

gem "sass-rails", "~> 5.0"
gem "uglifier"
gem "bootstrap-sass"
gem "font-awesome-sass"

gem "modernizr-rails"
gem "momentjs-rails"

gem "omniauth-twitter"

gem "activeadmin"

group :development do
  gem "pry-byebug"
  gem "pry-rails"
  gem "spring"
  gem "annotate"
end

group :development, :test do
  gem "letter_opener"
  gem "faker"
  gem "rspec-rails", git: "https://github.com/rspec/rspec-rails", branch: "4-0-dev"
  gem "rspec-its"
  gem "rails-controller-testing"
  gem "factory_bot_rails"
end

group :test do
  gem "shoulda-matchers"
end

group :production do
  gem "rails_12factor"
  gem "puma"
  gem "rack-timeout"
end
