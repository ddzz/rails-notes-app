class NotesController < ApplicationController
  before_action :check_user_logged_in

  def show
    @note = current_user.notes.find(params[:id])
    redirect_to notes_path if @note.nil?
  end

  def edit
    @note = current_user.notes.find(params[:id])
    redirect_to notes_path if @note.nil?
  end

  def index
    @user = current_user
    @notes = current_user.notes.all
  end

  def create
    @note = current_user.notes.build(note_params)
    if @note.save
      flash[:success] = "Note created!"
    else
      flash[:danger] = "Note not created. Please create a valid note."
    end

    redirect_to notes_path
  end

  def update
    @note = current_user.notes.find(params[:id])
    if @note.update_attributes(note_params)
      if email_params.present?
        NoteMailer.note_email(@note, email_params).deliver_now
        flash[:success] = "Note updated and emailed to #{email_params}!"
      else
        flash[:success] = "Note updated!"
      end
    else
      flash[:danger] = "Note not updated. Please try again."
    end

    redirect_to notes_path
  end

  def destroy
    @note = current_user.notes.find(params[:id])
    if @note.destroy
      flash[:success] = "Note deleted!"
    else
      flash[:danger] = "Note not deleted. Please try again."
    end

    redirect_to notes_path
  end

  private

  def check_user_logged_in
    if !logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def note_params
    params.require(:note).permit(:title, :body)
  end

  def email_params
    params.require(:note).permit(:email_address)[:email_address]
  end
end
