class DestinationsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_destination

  def edit
  end

  # PATCH
  def set_latest_entry
    # update for FE-FW
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
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_destination
      @destination = Destination.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def latest_entry_params
      params.require(:destination).permit(:latest_entry)
    end
end
