class WelcomeController < ApplicationController
  def welcome
    @user = User.new
  end
end
