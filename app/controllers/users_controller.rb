class UsersController < ApplicationController
  def show
    if current_user.nil?
      redirect_to root_url
    end
    @user = current_user
  end
end
