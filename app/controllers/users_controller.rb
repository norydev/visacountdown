class UsersController < ApplicationController
  skip_before_action :authenticate_user!

  def latest_entry
    @user = current_or_guest_user
    if latest_params[:is_in_turkey] == "Yes"
      @user.is_in_turkey = true
    else
      @user.is_in_turkey = false
    end

    @user.latest_entry = latest_params[:latest_entry]

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
      params.require(:user).permit(:latest_entry, :is_in_turkey)
    end
end
