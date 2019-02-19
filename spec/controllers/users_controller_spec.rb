require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before(:context) do
    @user = FactoryBot.create :user
  end

  describe "PATCH #set_citizenship" do
    context "with valid params" do
      let(:new_attributes) { { citizenship: "Belgium" } }

      it 'updates the requested user' do
        sign_in @user
        patch :set_citizenship, params: { id: @user.to_param, user: new_attributes }
        @user.reload
        expect(assigns(:user)).to have_attributes new_attributes
      end

      it "assigns the requested user as @user" do
        sign_in @user
        patch :set_citizenship, params: { id: @user.to_param, user: { citizenship: COUNTRIES.sample } }
        expect(assigns(:user)).to eq(@user)
      end

      it "redirects to the root_path" do
        sign_in @user
        patch :set_citizenship, params: { id: @user.to_param, user: { citizenship: COUNTRIES.sample } }
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid params" do
      it "assigns the user as @user" do
        sign_in @user
        patch :set_citizenship, params: { id: @user.to_param, user: { citizenship: "Rhodesia" } }
        expect(assigns(:user)).to eq(@user)
      end

      it "re-renders the 'edit' template" do
        sign_in @user
        patch :set_citizenship, params: { id: @user.to_param, user: { citizenship: "Rhodesia" } }
        expect(response).to render_template("edit")
      end
    end
  end
end
