class SessionsController < ApplicationController
  def new
  end

  def create
    if auth = request.env["omniauth.auth"]
      @user = User.find_or_create_by_omniauth(auth)
      session[:user_id] = @user.id
      redirect_to root_path
    else
      @user = User.find_by(username: params[:username])
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        flash[:message] = "Successfully logged in!"
        redirect_to root_path
      else
        flash[:errors] = "Something went wrong!"
        redirect_to login_path
      end
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end
end
