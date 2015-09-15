class UsersController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_user

  # PATCH
  def set_citizenship
    # update for FE-FW
    if @user.update(citizenship_params)
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Your citizenship has been updated.' }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js
      end
    end
  end

  # PATCH
  def set_latest_location
    # update for FE-FW
    if @user.update(latest_location_params)
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Your latest location has been updated.' }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id]) # was current_or_guest_user
    end

    # Only allow a trusted parameter "white list" through.
    def latest_location_params
      params.require(:user).permit(:latest_entry, :location)
    end

    # Only allow a trusted parameter "white list" through.
    def citizenship_params
      params.require(:user).permit(:citizenship)
    end
end
