class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:message] = "Successfully Signed Up!"
      redirect_to items_path
    else
      flash[:errors] = "Could not create new account: #{@user.errors.full_messages.to_sentence}"
      render :new
    end
  end

  def show
    @user = current_user
  end

  private
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
