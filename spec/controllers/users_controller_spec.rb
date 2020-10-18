require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  context "GET #show" do
    it "redirects to the login page when the user is not logged in" do
      get :show, params: { id: 1 }

      expect(response.status).to eql(302)
      expect(response.redirect?).to be_truthy
      expect(flash[:danger]).to match(/Please log in./)
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

  context "GET #new" do
    it "redirects to the user page if already logged in" do
      @test_user = User.create!(name: "Test User", email: "test@example.com", password: "password", password_confirmation: "password")
      allow_any_instance_of(described_class).to receive(:current_user).and_return(@test_user)
      get :new

      expect(response.status).to eql(302)
      expect(response.redirect?).to be_truthy
      expect(response.redirect_url).to end_with("users/#{@test_user.id}")
    end

    it "creates a new User when not logged in" do
      get :new

      expect(response.status).to eql(200)
      expect(assigns(:user)).to be_instance_of(User)
      expect(assigns(:user)).not_to be_valid
    end
  end

  context "POST #create" do
    it "creates a new User object with valid parameters" do
      post :create, params: { user: {name: "Test User", email: "test@example.com", password: "password", password_confirmation: "password"} }

      expect(response.status).to eql(302)
      expect(User.count).to eql(1)
      expect(assigns(:user).name).to eql("Test User")
      expect(assigns(:user).email).to eql("test@example.com")
      expect(flash[:success]).to match(/Account created!/)
      expect(response.redirect_url).to end_with("/users/#{assigns(:user).id}")
    end

    it "does not create a new User when parameters are invalid" do
      post :create, params: { user: {name: "Test User", email: "test@example.com", password: "password", password_confirmation: "bad_password"} }

      expect(User.count).to eql(0)
      expect(assigns(:user).name).to eql("Test User")
      expect(assigns(:user).email).to eql("test@example.com")
      expect(flash[:danger]).to match(/Account not created. Please try again./)
    end
  end
end
