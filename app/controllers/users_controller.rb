class UsersController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_user, only: [:edit, :set_citizenship]

  # GET
  def edit
    user_not_authorized unless @user == current_or_guest_user
  end

  # PATCH
  def set_citizenship
    if @user == current_or_guest_user
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
    else
      user_not_authorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id]) # was current_or_guest_user
    end

    # Only allow a trusted parameter "white list" through.
    def citizenship_params
      params.require(:user).permit(:citizenship)
    end
end
