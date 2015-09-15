require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:valid_session) { {} }

  describe "PATCH #set_citizenship" do
    context "with valid params" do
      let(:new_attributes) {
        {citizenship: "Belgium"}
      }

      it 'updates the requested user' do
        user = FactoryGirl.create :user
        patch :set_citizenship, {id: user.to_param, user: new_attributes}, valid_session
        user.reload
        expect(assigns(:user)).to have_attributes new_attributes
      end

      it "assigns the requested user as @user" do
        user = FactoryGirl.create :user
        patch :set_citizenship, {id: user.to_param, user: {citizenship: COUNTRIES.sample}}, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it "redirects to the root_path" do
        user = FactoryGirl.create :user
        patch :set_citizenship, {id: user.to_param, user: {citizenship: COUNTRIES.sample}}, valid_session
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid params" do
      it "assigns the period as @user" do
        user = FactoryGirl.create :user
        patch :set_citizenship, {:id => user.to_param, :user => {citizenship: "Rhodesia" }}, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it "re-renders the 'edit' template" do
        user = FactoryGirl.create :user
        patch :set_citizenship, {:id => user.to_param, :user => {citizenship: "Rhodesia" }}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "PATCH #set_latest_location" do
    context "with valid params" do
      let(:new_attributes) {
        {location: "Turkey", latest_entry: 5.days.ago}
      }

      it 'updates the requested user' do
        user = FactoryGirl.create :user
        patch :set_latest_location, {id: user.to_param, user: new_attributes}, valid_session
        user.reload
        expect(assigns(:user)).to have_attributes(location: "Turkey", latest_entry: Date.parse(5.days.ago.to_s))
      end

      it "assigns the requested user as @user" do
        user = FactoryGirl.create :user
        patch :set_latest_location, {id: user.to_param, user: { location: ZONES.sample, latest_entry: rand(30).days.ago }}, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it "redirects to the root_path" do
        user = FactoryGirl.create :user
        patch :set_latest_location, {id: user.to_param, user: { location: ZONES.sample, latest_entry: rand(30).days.ago }}, valid_session
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid params" do
      it "assigns the period as @user" do
        user = FactoryGirl.create :user
        patch :set_latest_location, {:id => user.to_param, :user => { location: "Russia", latest_entry: nil }}, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it "re-renders the 'edit' template" do
        user = FactoryGirl.create :user
        patch :set_latest_location, {:id => user.to_param, :user => { location: "Russia", latest_entry: nil }}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end
end
