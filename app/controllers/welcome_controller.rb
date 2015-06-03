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
    elsif @user.citizenship && @user.destination && @user.latest_entry
      redirect_to welcome_calculator_path
    else
      redirect_to welcome_empty_user_path
    end
  end

  def empty_user
    @user = current_or_guest_user
    @countries = COUNTRIES.map{ |key, val| key }.sort

    render 'index'
  end

  def new_index
    @user = current_or_guest_user
    if user_signed_in?
      redirect_to dashboard_path
    elsif @user.citizenship && @user.destination && @user.latest_entry
      redirect_to welcome_calculator_path
    else
      redirect_to user_details_path
    end
  end

  #POST method, comes from index
  def user_details
    @details = user_details_params

    @user = current_or_guest_user

    @user.citizenship = @details["citizenship"]
    @user.destination = @details["destination"]
    @user.latest_entry = @details["latest_entry"]
    @user.save

    redirect_to welcome_calculator_path
  end

  def calculator

    @user = current_or_guest_user

    unless @user.citizenship && @user.destination && @user.latest_entry
      redirect_to root_path
    end

    @countries = COUNTRIES.map{ |key, val| key }.sort

    if COUNTRIES[@user.citizenship][@user.destination]["visa"] == "evisa_90_180"
      @situation = "e-visa"
    elsif COUNTRIES[@user.citizenship][@user.destination]["visa"] == "no_visa_90_180"
      @situation = "no_visa"
    else
      @situation = "error"
    end

    # render 'add_periods'
  end

  def add_empty
    @next_id = params[:id].to_i + 1
    respond_to do |format|
      format.html { redirect_to root_path } #change
      format.js
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def user_details_params
      params.require(:resource).permit(:citizenship, :destination, :latest_entry)
    end

end
