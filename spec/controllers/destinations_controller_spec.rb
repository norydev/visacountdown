require 'rails_helper'

RSpec.describe DestinationsController, type: :controller do
  describe "PATCH #set_latest_entry" do
    let(:new_attributes) { { latest_entry: 5.days.ago } }

    before(:each) do
      @user = FactoryBot.create :user
      @destination = FactoryBot.create :destination, user: @user
    end

    it 'updates the requested destination' do
      sign_in @user
      patch :set_latest_entry, params: { id: @destination.id, destination: new_attributes }
      @destination.reload
      expect(assigns(:destination)).to have_attributes(latest_entry: Date.parse(5.days.ago.to_s))
    end

    it "assigns the requested destination as @destination" do
      sign_in @user
      patch :set_latest_entry, params: { id: @destination.id, destination: { latest_entry: rand(30).days.ago } }
      expect(assigns(:destination)).to eq(@destination)
    end

    it "redirects to the root_path" do
      sign_in @user
      patch :set_latest_entry, params: { id: @destination.id, destination: { latest_entry: rand(30).days.ago } }
      expect(response).to redirect_to(root_path)
    end
  end
end
