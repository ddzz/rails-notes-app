class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to current_user
    else
      render 'new'
    end
  end

  def create
    user = User.find_by(email: email_params)
    if user && user.authenticate(password_params)
      session[:user_id] = user.id
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination.'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def email_params
    params[:session][:email].downcase
  end

  def password_params
    params[:session][:password]
  end
end
