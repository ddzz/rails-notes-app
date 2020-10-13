class NotesController < ApplicationController
  def show
    @note = current_user.notes.find(params[:id])
  end

  def create
    @note = current_user.notes.build(note_params)
    if @note.save
      flash[:success] = "Note created!"
    else
      flash[:danger] = "Note not created. Please create a valid note."
    end

    redirect_to current_user
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

    redirect_to current_user
  end

  def destroy
    @note = current_user.notes.find(params[:id])
    if @note.destroy
      flash[:success] = "Note deleted!"
    else
      flash[:danger] = "Note not deleted. Please try again."
    end

    redirect_to current_user
  end

  private

  def note_params
    params.require(:note).permit(:title, :body)
  end

  def email_params
    params.require(:note).permit(:email_address)[:email_address]
  end
end
