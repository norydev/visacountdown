class PeriodsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_period, only: [:show, :edit, :update, :destroy]

  skip_before_filter :verify_authenticity_token, only: :create

  # GET /periods
  def index
    @periods = Period.all
  end

  # GET /periods/1
  def show
  end

  # GET /periods/new
  def new
    @period = Period.new
    @period.user = current_or_guest_user
  end

  # GET /periods/1/edit
  def edit
  end

  # POST /periods
  def create
    @period = Period.new(period_params)
    @period.user = current_or_guest_user

    if @period.save
      respond_to do |format|
        format.html { redirect_to @period, notice: 'Period was successfully created.' }
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
    if @period.update(period_params)
      redirect_to @period, notice: 'Period was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /periods/1
  def destroy
    @id = @period.id
    @period.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Period was successfully destroyed.' }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_period
      @period = Period.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def period_params
      params.require(:period).permit(:first_day, :last_day)
    end
end
