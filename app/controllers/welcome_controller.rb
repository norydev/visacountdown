class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @time_now = Time.zone.now.strftime("%B %d, %Y - %H:%M")
    @today = Time.zone.now.to_date
    @oldest_date = (Time.zone.now.to_date - 179).strftime("%B %d, %Y")
    @user = current_or_guest_user
    @periods = @user.periods.order(:last_day)

    @regulations = COUNTRIES
    @countries = COUNTRIES.map{ |key, val| key }.sort

    if @user.latest_entry
      @time_spent_today = @user.time_spent(@today)
      @latest_entry = @user.latest_entry.strftime("%B %d, %Y")
      case @time_spent_today
        when 0..89
          if @user.is_in_turkey?
            # calc days remaining from now to know when to leave
            @situation = "inside_ok"
            @remaining_time = @user.remaining_time
            @leave_on = @user.latest_exit.strftime("%B %d, %Y")
          else
            # exit day with latest exit given
            @situation = "outside_ok"
            @remaining_time = @user.remaining_time(@user.latest_entry)
            @leave_on = @user.latest_exit.strftime("%B %d, %Y")
          end
        when 90..180
          if @user.is_in_turkey?
            # overstay: get out
            @situation = "overstay"
          else
            # quota user: next it, next out
            @situation = "quota_used"
            @next_entry = @user.next_entry
            @can_enter = (@user.latest_entry - @next_entry).to_i >= 0

            if @can_enter
              @remaining_time = @user.remaining_time(@user.latest_entry, true)
              @leave_on = (@user.latest_entry + @remaining_time - 1).strftime("%B %d, %Y")
            else
              @remaining_time = @user.remaining_time(@next_entry, true)
              @leave_on = (@next_entry + @remaining_time - 1).strftime("%B %d, %Y")
            end
          end
      end
    end

    if user_signed_in?
      render 'dashboard'
    else
      render 'index'
    end

  end
end
