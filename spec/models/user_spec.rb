require 'rails_helper'

RSpec.describe User, type: :model do
  context "validations" do
    it "creates a user with valid parameters" do
      user = User.create(name: "Hello World", email: "test@example.com", password: "password", password_confirmation: "password")
      expect(user).to be_valid
    end

    it "does not allow duplicate email addresses" do
      user_1 = User.create(name: "Hello World", email: "test@example.com", password: "password", password_confirmation: "password")
      user_2 = User.create(name: "Test User", email: "test@example.com", password: "password", password_confirmation: "password")

      expect(user_1).to be_valid
      expect(user_2).not_to be_valid
      expect(user_2.errors.messages[:email][0]).to eql("has already been taken")
    end

    it "must have a name" do
      user = User.create(email: "test@example.com", password: "password", password_confirmation: "password")

      expect(user).not_to be_valid
      expect(user.errors.messages[:name][0]).to eql("can't be blank")
    end

    it "does not allow short passwords" do
      user = User.create(name: "Test User", email: "test@example.com", password: "pass", password_confirmation: "pass")

      expect(user).not_to be_valid
      expect(user.errors.messages[:password][0]).to eql("is too short (minimum is 6 characters)")
    end

    it "can have many Notes" do
      user = User.create(name: "Test User", email: "test@example.com", password: "password", password_confirmation: "password")
      user.notes.create(title: "Test title", body: "Test Body")
      user.notes.create(title: "Test title 2", body: "Test Body 2")
      expect(user).to be_valid
      expect(user.notes.count).to eql(2)
    end
  end
end
