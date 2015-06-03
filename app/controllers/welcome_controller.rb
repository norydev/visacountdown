class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @user = current_or_guest_user

    if user_signed_in?
      welcome_results_path
    elsif @user.citizenship && @user.destination && @user.latest_entry
      redirect_to welcome_calculator_path
    else
      redirect_to welcome_empty_user_path
    end
  end

  def empty_user
    @user = current_or_guest_user
    @countries = COUNTRIES.map{ |key, val| key }.sort

    @latest_entry = @user.latest_entry.strftime("%d %b %Y") if @user.latest_entry

    render 'index'
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

    @first_day = @user.periods.where(zone: @user.destination).last.first_day.strftime("%d %b %Y") unless @user.periods.where(zone: @user.destination).empty?
    @last_day = @user.periods.where(zone: @user.destination).last.last_day.strftime("%d %b %Y") unless @user.periods.where(zone: @user.destination).empty?

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
  end

  #POST calculation
  def calculation
    @user = current_or_guest_user
    @params = periods_params

    # brutal but simpler than edit...
    @user.periods.where(zone: @user.destination).destroy_all

    (0...@params[:first_day].size).each do |i|
      p = Period.new(user: @user, first_day: periods_params[:first_day][i], last_day: periods_params[:last_day][i], zone: @user.destination)
      p.save
    end

    redirect_to welcome_results_path
  end

  # show results
  def results
    @time_now = Time.zone.now.strftime("%B %d, %Y - %H:%M")
    @today = Time.zone.now.to_date
    @oldest_date = (Time.zone.now.to_date - 179).strftime("%d %b %Y")
    @user = current_or_guest_user
    @periods = @user.periods.order(:last_day)

    @regulations = COUNTRIES
    @countries = COUNTRIES.map{ |key, val| key }.sort

    if @user.latest_entry
      @time_spent_today = @user.time_spent(@today)
      @latest_entry = @user.latest_entry.strftime("%d %b %Y")
      case @time_spent_today
        when 0..89
          if @user.is_in_zone?
            # calc days remaining from now to know when to leave
            @situation = "inside_ok"
            @remaining_time = @user.remaining_time
            @leave_on = @user.latest_exit.strftime("%d %b %Y")
          else
            # exit day with latest exit given
            @situation = "outside_ok"
            @remaining_time = @user.remaining_time(@user.latest_entry)
            @leave_on = @user.latest_exit.strftime("%d %b %Y")
          end
        when 90..180
          if @user.is_in_zone?
            # overstay: get out
            @situation = "overstay"
          else
            # quota user: next it, next out
            @situation = "quota_used"
            @next_entry = @user.next_entry
            @can_enter = (@user.latest_entry - @next_entry).to_i >= 0

            if @can_enter
              @remaining_time = @user.remaining_time(@user.latest_entry, true)
              @leave_on = (@user.latest_entry + @remaining_time - 1).strftime("%d %b %Y")
            else
              @remaining_time = @user.remaining_time(@next_entry, true)
              @leave_on = (@next_entry + @remaining_time - 1).strftime("%d %b %Y")
            end
          end
      end
    end

    if user_signed_in?
      render 'dashboard'
    end
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

    def periods_params
      params.require(:resource).permit(first_day: [], last_day: [])
    end

end
