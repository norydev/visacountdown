require 'rails_helper'

RSpec.describe PeriodsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Period. As you add validations to Period, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    FactoryGirl.attributes_for(:period)
  }

  let(:invalid_attributes) {
    {first_day: "4 july 1776", last_day: nil, zone: "Cyprus"}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PeriodsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let(:periods) { Period.all }

  before(:context) do
    @user = FactoryGirl.create :user
    @destination = FactoryGirl.create :destination, user: @destination

    10.times do
      FactoryGirl.create :period, destination: @destination
    end
  end

  describe "GET #index" do
    it "assigns all periods as @periods" do
      get :index, {}, valid_session
      expect(assigns(:periods)).to eq(periods)
    end
  end

  describe "GET #show" do
    it "assigns the requested period as @period" do
      period = FactoryGirl.create :period, destination: @destination
      get :show, {:id => period.to_param}, valid_session
      expect(assigns(:period)).to eq(period)
    end
  end

  describe "GET #new" do
    it "assigns a new period as @period" do
      get :new, {}, valid_session
      expect(assigns(:period)).to be_a_new(Period)
    end
  end

  describe "GET #edit" do
    it "assigns the requested period as @period" do
      period = FactoryGirl.create :period, destination: @destination
      get :edit, {:id => period.to_param}, valid_session
      expect(assigns(:period)).to eq(period)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Period" do
        expect {
          post :create, {:period => valid_attributes}, valid_session
        }.to change(Period, :count).by(1)
      end

      it "assigns a newly created period as @period" do
        post :create, {:period => valid_attributes}, valid_session
        expect(assigns(:period)).to be_a(Period)
        expect(assigns(:period)).to be_persisted
      end

      it "redirects to the created period" do
        post :create, {:period => valid_attributes}, valid_session
        expect(response).to redirect_to(Period.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved period as @period" do
        post :create, {:period => invalid_attributes}, valid_session
        expect(assigns(:period)).to be_a_new(Period)
      end

      it "re-renders the 'new' template" do
        post :create, {:period => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {zone: "Schengen area", first_day: 5.days.ago, last_day: 2.days.ago}
      }

      it "updates the requested period" do
        period = FactoryGirl.create :period, destination: @destination
        put :update, {:id => period.to_param, :period => new_attributes}, valid_session
        period.reload
        expect(assigns(:period)).to have_attributes(zone: "Schengen area", first_day: Date.parse(5.days.ago.to_s), last_day: Date.parse(2.days.ago.to_s))
      end

      it "assigns the requested period as @period" do
        period = FactoryGirl.create :period, destination: @destination
        put :update, {:id => period.to_param, :period => valid_attributes}, valid_session
        expect(assigns(:period)).to eq(period)
      end

      it "redirects to the period" do
        period = FactoryGirl.create :period, destination: @destination
        put :update, {:id => period.to_param, :period => valid_attributes}, valid_session
        expect(response).to redirect_to(period)
      end
    end

    context "with invalid params" do
      it "assigns the period as @period" do
        period = FactoryGirl.create :period, destination: @destination
        put :update, {:id => period.to_param, :period => invalid_attributes}, valid_session
        expect(assigns(:period)).to eq(period)
      end

      it "re-renders the 'edit' template" do
        period = FactoryGirl.create :period, destination: @destination
        put :update, {:id => period.to_param, :period => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested period" do
      period = FactoryGirl.create :period, destination: @destination
      expect {
        delete :destroy, {:id => period.to_param}, valid_session
      }.to change(Period, :count).by(-1)
    end

    it "redirects to the periods list" do
      period = FactoryGirl.create :period, destination: @destination
      delete :destroy, {:id => period.to_param}, valid_session
      expect(response).to redirect_to(root_path)
    end
  end

end
