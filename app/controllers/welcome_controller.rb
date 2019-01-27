class WelcomeController < ApplicationController
  def welcome
    @item = Item.new
  end
end
