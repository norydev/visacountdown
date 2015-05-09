class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @time_now = Time.zone.now.strftime("%B %d, %Y - %H:%M")
    @oldest_date = (Time.zone.now.to_date - 179).strftime("%B %d, %Y")
    @user = current_or_guest_user
    @periods = current_or_guest_user.periods.order(:last_day)
  end
end
