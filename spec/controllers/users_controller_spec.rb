require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  context "GET #show" do
    it "redirects to the login page when the user is not logged in" do
      get :show, params: { id: 1 }

      expect(response.status).to eql(302)
      expect(response.redirect?).to be_truthy
      expect(response.redirect_url).to eql("http://test.host/")
    end

    it "returns the correct user when the user is logged in" do
      @test_user = User.create!(name: "Test User", email: "test@example.com", password: "password", password_confirmation: "password")
      allow_any_instance_of(described_class).to receive(:current_user).and_return(@test_user)
      get :show, params: { id: @test_user.id }

      expect(response.status).to eql(200)
      expect(assigns(:user)).to eql(@test_user)
    end
  end
end
