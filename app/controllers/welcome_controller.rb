class WelcomeController < ApplicationController
  def welcome
    if logged_in?
      @item = Item.new
    else
      render :login
    end
  end
end
