class UsersController < ApplicationController
  def new
    redirect_to current_user if current_user
    @user = User.new
  end

  def show
    if current_user.nil?
      flash[:danger] = "Please log in."
      redirect_to root_url
    else
      redirect_to current_user if params[:id] != current_user&.id&.to_s
      @user = current_user
    end
  end

  def create
    redirect_to current_user if current_user
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Account created!"
      redirect_to @user
    else
      flash[:danger] = "Account not created. Please try again."
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
