class NoteMailer < ApplicationMailer
  def note_email(note, email_address)
    @note = note
    @email_address = email_address
    mail(to: @email_address, subject: "A note for you...")
  end
end
