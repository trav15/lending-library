class StaticController < ApplicationController
  def welcome
    @user = User.new
  end
end
