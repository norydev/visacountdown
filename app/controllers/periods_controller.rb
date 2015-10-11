class PeriodsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_period, only: [:show, :edit, :update, :destroy]
  before_action :get_destination, only: [:create, :update]

  # GET /periods/new
  def new
    @period = Period.new(zone: params[:zone])
  end

  # GET /periods/1/edit
  def edit
  end

  # POST /periods
  def create
    @period = Period.new(period_params)
    @period.destination = @destination

    if @period.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Period was successfully created.' }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js
      end
    end
  end

  # PATCH/PUT /periods/1
  def update
    @period.destination = @destination
    if @period.update(period_params)
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Period was successfully updated.' }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js
      end
    end
  end

  # DELETE /periods/1
  def destroy
    @period.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Period was successfully deleted.' }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_period
      # might need to change to period_params[:id] and pass it in the form (SPA)
      @period = Period.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def period_params
      params.require(:period).permit(:first_day, :last_day, :zone)
    end

    def get_destination
      @destination = Destination.where(user: current_or_guest_user, zone: period_params[:zone]).first_or_create
    end
end
