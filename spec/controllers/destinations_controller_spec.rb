require 'rails_helper'

RSpec.describe DestinationsController, type: :controller do

  let(:valid_session) { {} }

  describe "PATCH #set_latest_entry" do
    context "with valid params" do
      let(:new_attributes) { { latest_entry: 5.days.ago } }

      it 'updates the requested destination' do
        destination = FactoryGirl.create :destination
        patch :set_latest_entry, { id: destination.to_param, destination: new_attributes }, valid_session
        destination.reload
        expect(assigns(:destination)).to have_attributes(latest_entry: Date.parse(5.days.ago.to_s))
      end

      it "assigns the requested destination as @destination" do
        destination = FactoryGirl.create :destination
        patch :set_latest_entry, { id: destination.to_param, destination: { latest_entry: rand(30).days.ago } }, valid_session
        expect(assigns(:destination)).to eq(destination)
      end

      it "redirects to the root_path" do
        destination = FactoryGirl.create :destination
        patch :set_latest_entry, { id: destination.to_param, destination: { latest_entry: rand(30).days.ago } }, valid_session
        expect(response).to redirect_to(root_path)
      end
    end
  end

end
