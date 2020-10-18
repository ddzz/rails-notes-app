require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  context "GET #new" do
    it "redirects to the user's page when the user is logged in" do
      @test_user = User.create!(name: "Test User", email: "test@example.com", password: "password", password_confirmation: "password")
      allow_any_instance_of(described_class).to receive(:current_user).and_return(@test_user)
      get :new

      expect(response.status).to eql(302)
      expect(response.redirect?).to be_truthy
      expect(response.redirect_url).to end_with("users/#{@test_user.id}")
    end

    it "renders the login page when the user is not logged in" do
      get :new

      expect(get(:new)).to render_template('new')
      expect(response.status).to eql(200)
    end
  end

  context "POST #create" do
    before(:each) do
      @user = User.create!(name: "Test User", email: "test@example.com", password: "password", password_confirmation: "password")
    end

    it "logs in when credentials are valid" do
      post :create, params: { session: {email: "test@example.com", password: "password"} }

      expect(session[:user_id]).to eql(@user.id)
      expect(response.redirect_url).to end_with("users/#{@user.id}")
    end

    it "does not create a New note when parameters are invalid" do
      post :create, params: { session: {email: "test@example.com", password: "bad_password"} }

      expect(session[:user_id]).to eql(nil)
      expect(flash[:danger]).to eql("Invalid email/password combination.")
      expect(post :create, params: { session: {email: "test@example.com", password: "bad_password"} }).to render_template('new')
    end
  end

  context "DELETE #destroy" do
    before(:each) do
      @user = User.create!(name: "Test User", email: "test@example.com", password: "password", password_confirmation: "password")
    end

    it "redirects to the user's page when the user is logged in" do
      allow_any_instance_of(described_class).to receive(:log_out).and_return(true)
      expect_any_instance_of(described_class).to receive(:log_out)
      delete :destroy, params: { id: @user.id }

      expect(session[:user_id]).to eql(nil)
      expect(response.status).to eql(302)
      expect(response.redirect?).to be_truthy
      expect(response.redirect_url).to eql("http://test.host/")
    end
  end
end
