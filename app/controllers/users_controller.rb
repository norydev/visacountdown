class UsersController < ApplicationController
  skip_before_action :authenticate_user!

  def latest_entry

    @time_now = Time.zone.now.strftime("%B %d, %Y - %H:%M")
    @today = Time.zone.now.to_date
    @oldest_date = (Time.zone.now.to_date - 179).strftime("%d %b %Y")

    @user = current_or_guest_user

    @user.latest_entry = latest_params[:latest_entry]

    @periods = @user.periods.order(:last_day)
    @latest_entry = @user.latest_entry.strftime("%d %b %Y") if @user.latest_entry

    if @user.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Your countdown has been calculated.' }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js
      end
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def latest_params
      params.require(:user).permit(:latest_entry)
    end
end
