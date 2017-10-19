class DashboardController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_user

  def index
    @destinations = @user.destinations.includes(:periods)
  end

  private

    def set_user
      @user = current_or_guest_user
    end
end
