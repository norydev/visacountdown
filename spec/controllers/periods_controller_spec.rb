require 'rails_helper'

RSpec.describe PeriodsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Period. As you add validations to Period, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { FactoryBot.attributes_for(:period) }

  let(:invalid_attributes) { { first_day: "4 july 1776", last_day: nil, zone: "Cyprus" } }

  let(:periods) { Period.all }

  before(:context) do
    @user = FactoryBot.create :user
    @destination = FactoryBot.create :destination, user: @user

    10.times do
      FactoryBot.create :period, destination: @destination
    end
  end

  describe "GET #new" do
    it "assigns a new period as @period" do
      get :new
      expect(assigns(:period)).to be_a_new(Period)
    end
  end

  describe "GET #edit" do
    it "assigns the requested period as @period" do
      period = FactoryBot.create :period, destination: @destination
      get :edit, params: { id: period.to_param }
      expect(assigns(:period)).to eq(period)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Period" do
        expect { post :create, params: { period: valid_attributes } }.to change(Period, :count).by(1)
      end

      it "assigns a newly created period as @period" do
        post :create, params: { period: valid_attributes }
        expect(assigns(:period)).to be_a(Period)
        expect(assigns(:period)).to be_persisted
      end

      it "redirects to the created period" do
        post :create, params: { period: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved period as @period" do
        post :create, params: { period: invalid_attributes }
        expect(assigns(:period)).to be_a_new(Period)
      end

      it "re-renders the 'new' template" do
        post :create, params: { period: invalid_attributes }
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { zone: "Schengen area", first_day: 5.days.ago, last_day: 2.days.ago } }

      it "updates the requested period" do
        sign_in @user
        period = FactoryBot.create :period, destination: @destination
        put :update, params: { id: period.to_param, period: new_attributes }
        period.reload
        expect(assigns(:period)).to have_attributes(zone: "Schengen area", first_day: Date.parse(5.days.ago.to_s), last_day: Date.parse(2.days.ago.to_s))
      end

      it "assigns the requested period as @period" do
        sign_in @user
        period = FactoryBot.create :period, destination: @destination
        put :update, params: { id: period.to_param, period: valid_attributes }
        expect(assigns(:period)).to eq(period)
      end

      it "redirects to the period" do
        sign_in @user
        period = FactoryBot.create :period, destination: @destination
        put :update, params: { id: period.to_param, period: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid params" do
      it "assigns the period as @period" do
        sign_in @user
        period = FactoryBot.create :period, destination: @destination
        put :update, params: { id: period.to_param, period: invalid_attributes }
        expect(assigns(:period)).to eq(period)
      end

      it "re-renders the 'edit' template" do
        sign_in @user
        period = FactoryBot.create :period, destination: @destination
        put :update, params: { id: period.to_param, period: invalid_attributes }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested period" do
      sign_in @user
      period = FactoryBot.create :period, destination: @destination
      expect { delete :destroy, params: { id: period.to_param } }.to change(Period, :count).by(-1)
    end

    it "redirects to the periods list" do
      sign_in @user
      period = FactoryBot.create :period, destination: @destination
      delete :destroy, params: { id: period.to_param }
      expect(response).to redirect_to(root_path)
    end
  end

end
