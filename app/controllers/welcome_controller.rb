class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @time_now = Time.zone.now.strftime("%B %d, %Y - %H:%M")
    @today = Time.zone.now.to_date
    @oldest_date = (Time.zone.now.to_date - 179).strftime("%B %d, %Y")
    @user = current_or_guest_user
    @periods = @user.periods.order(:last_day)
    @latest_entry = @user.latest_entry.strftime("%B %d, %Y") if @user.latest_entry

  end
end
