class UsersController < ApplicationController
  skip_before_action :authenticate_user!

  def latest_entry
    @user = current_or_guest_user
    if latest_params[:is_inside] == "Yes"
      @user.is_in_turkey = true
      @user.latest_entry = latest_params[:last_entry]
    else
      @user.is_in_turkey = false
      @user.latest_entry = nil
    end

    if @user.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Your infos have been updated.' }
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
      params.require(:latest).permit(:last_entry, :is_inside)
    end
end
