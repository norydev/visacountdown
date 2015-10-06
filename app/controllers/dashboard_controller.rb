class DashboardController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_user

  def index
    redirect_to edit_user_path(@user) unless @user.citizenship
  end

  private

    def set_user
      @user = current_or_guest_user
    end
end
