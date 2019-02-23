class DestinationsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_destination

  def edit
    user_not_authorized unless current_or_guest_user.destinations.include?(@destination)
  end

  def set_latest_entry
    if current_or_guest_user.destinations.include?(@destination)
      if @destination.update(latest_entry_params)
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
    else
      user_not_authorized
    end
  end

  private

    def set_destination
      @destination = Destination.find(params[:id])
    end

    def latest_entry_params
      params.require(:destination).permit(:latest_entry)
    end
end
