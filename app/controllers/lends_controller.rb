class LendsController < ApplicationController
  def create
    @item = Item.find_by(id: params[:item_id])
    if !@item
      flash[:errors] = "Item not found"
      redirect_to items_path
    end

    @lend = current_user.lends.find_or_initialize_by(item: @item)
    if @lend.update(lend_params)
      flash[:message] = "Congratulations! You have borrowed this item!"
      @lend.update(return_date: nil)
      @lend.item.update(available: false)
      redirect_to item_path(@item)
    else
      flash[:errors] = "Sorry, something went wrong!"
      redirect_to item_path(@lend.item)
    end
  end

  def index
    @user = current_user
    @lends = Lend.where(user_id: @user.id).where(return_date: nil).all
  end

  def update
    @lend = Lend.find_by(id: params[:id])
    if @lend.update(lend_params)
      @lend.item.update(available: true)
      flash[:message] = "Item successfully returned!"
      redirect_to user_lends_path(user_id: @lend.user.id)
    else
      flash[:errors] = "Could not return item"
      redirect_to user_lends_path(user_id: params[:id])
    end
  end

  private
  def lend_params
    params.require(:lend).permit(:lend_date, :return_date)
  end
end
