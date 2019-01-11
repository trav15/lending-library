class LendsController < ApplicationController
  def create
    @item = Item.find_by(params[:item_id])
    if !@item
      flash[:message] = "Item not found"
      redirect_to items_path
    end

    @lend = current_user.lends.find_or_instantiate_by(item: @item)
    if @lend.update(lend_params)
      flash[:message] = "You have borrowed this item!"
      redirect_to item_path(@item)
    else
      flash[:message] = "Sorry, something went wrong!"
    end
    redirect_to item_path(@item)
  end

  private
  def lend_params
    params.require(:lend).permit(:lend_date)
  end
end
