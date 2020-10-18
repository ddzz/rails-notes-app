require 'rails_helper'

RSpec.describe Note, type: :model do
  context "validations" do
    it "requires a User association" do
      note = Note.create(title: "Test title", body: "Test body")
      expect(note).not_to be_valid
      expect(note.errors.messages[:user][0]).to eql("must exist")

      user = User.create(name: "Test User", email: "test@example.com", password: "password", password_confirmation: "password")
      note.user_id = user.id

      expect(note).to be_valid
    end

    it "can be created without a body" do
      user = User.create(name: "Test User", email: "test@example.com", password: "password", password_confirmation: "password")
      note = Note.create(title: "Test title", user_id: user.id)

      expect(note).to be_valid
    end

    it "uses the body for the title if no title is present for a new Note" do
      user = User.create(name: "Test User", email: "test@example.com", password: "password", password_confirmation: "password")
      note = Note.create(body: "Long Test Body", user_id: user.id)

      expect(note).to be_valid
      expect(note.title).to eql(note.body)
    end

    it "uses the body for the title if no title is present for an updated Note" do
      user = User.create(name: "Test User", email: "test@example.com", password: "password", password_confirmation: "password")
      note = Note.create(title: "Test Title", body: "Long Test Body", user_id: user.id)
      note.update(title: "")

      expect(note).to be_valid
      expect(note.title).to eql(note.body)
    end

    it "does not allow long titles" do
      user = User.create(name: "Test User", email: "test@example.com", password: "password", password_confirmation: "password")
      note = Note.create(title: "Very long title that is more than 30 characters long", body: "Test body", user_id: user.id)

      expect(note).not_to be_valid
      expect(note.errors.messages[:title][0]).to eql("is too long (maximum is 30 characters)")
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
