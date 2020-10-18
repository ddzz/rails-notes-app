require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  before(:each) do
    @user = User.create!(name: "Test User", email: "test@example.com", password: "password", password_confirmation: "password")
    @note_1 = Note.create!(title: "First Note", body: "First Note Body", user_id: @user.id)
    @note_2 = Note.create!(title: "Second Note", body: "Second Note Body", user_id: @user.id)
    allow_any_instance_of(described_class).to receive(:current_user).and_return(@user)
  end

  context "GET #show" do
    it "returns the correct Note object with valid Note ID" do
      get :show, params: { id: @note_1.id }

      expect(response.status).to eql(200)
      expect(assigns(:note)).to eql(@note_1)
    end

    it "raises error when Note ID is invalid" do
      expect { get :show, params: { id: 1369 } }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "GET #edit" do
    it "returns the correct Note object with valid Note ID" do
      get :edit, params: { id: @note_1.id }

      expect(response.status).to eql(200)
      expect(assigns(:note)).to eql(@note_1)
    end

    it "raises error when Note ID is invalid" do
      expect { get :show, params: { id: 1369 } }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "POST #create" do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:current_user).and_return(@user)
    end

    it "creates a new Note object with valid parameters" do
      post :create, params: { note: {title: "Test Title", body: "Test Body"} }

      expect(Note.count).to eql(3)
      expect(assigns(:note).title).to eql("Test Title")
      expect(assigns(:note).body).to eql("Test Body")
      expect(flash[:success]).to match(/Note created!/)
      expect(response.redirect_url).to end_with("/notes")
    end

    it "does not create a New note when parameters are invalid" do
      post :create, params: { note: {title: "Test Title that is too long for the 30 char limit", body: "Test Body"} }

      expect(Note.count).to eql(2)
      expect(assigns(:note)).not_to be_valid
      expect(flash[:danger]).to match(/Note not created. Please create a valid note./)
      expect(response.redirect_url).to end_with("/notes")
    end
  end

  context "PATCH #update" do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:current_user).and_return(@user)
      allow_any_instance_of(NoteMailer).to receive_message_chain(:note_email, :deliver_now).and_return(true)
    end

    it "updates a Note when parameters are valid" do
      put :update, params: { id: @note_1.id, note: {title: "Test Title", body: "Test Body"} }

      @note_1.reload
      expect(@note_1.title).to eql("Test Title")
      expect(@note_1.body).to eql("Test Body")
      expect(flash[:success]).to match(/Note updated!/)
      expect(response.redirect_url).to end_with("/notes")
    end

    it "updates a Note and sends an email when email address is included" do
      expect_any_instance_of(NoteMailer).to receive(:note_email)
      put :update, params: { id: @note_1.id, note: {title: "Test Title", body: "Test Body", email_address: "test@ex.com"} }

      @note_1.reload
      expect(@note_1.title).to eql("Test Title")
      expect(@note_1.body).to eql("Test Body")
      expect(flash[:success]).to match(/Note updated and emailed to test@ex.com!/)
      expect(response.redirect_url).to end_with("/notes")
    end

    it "does not update a Note when parameters are invalid" do
      put :update, params: { id: @note_1.id, note: {title: "Test Title that is too long and will be rejected", body: "Test Body"} }

      expect(assigns(:note)).not_to be_valid
      @note_1.reload
      expect(@note_1.title).to eql("First Note")
      expect(@note_1.body).to eql("First Note Body")
      expect(flash[:danger]).to match(/Note not updated. Please try again./)
      expect(response.redirect_url).to end_with("/notes")
    end
  end

  context "DELETE #destroy" do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:current_user).and_return(@user)
    end

    it "deletes the given Note" do
      delete :destroy, params: { id: @note_1.id }

      expect(Note.count).to eql(1)
      expect(assigns(:note)).to eql(@note_1)
      expect(flash[:success]).to match(/Note deleted!/)
      expect(response.redirect_url).to end_with("/notes")
    end
  end
end
