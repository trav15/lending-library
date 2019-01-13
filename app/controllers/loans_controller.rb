class LoansController < ApplicationController
  def create
    @item = Item.find_by(id: params[:item_id])
    if !@item
      flash[:errors] = "Item not found"
      redirect_to items_path
    end

    @loan = current_user.loans.find_or_initialize_by(item: @item, return_date: nil)
    if @loan.update(loan_params)
      flash[:message] = "Congratulations! You have borrowed this item!"
      @loan.update(return_date: nil)
      @loan.item.update(available: false)
      redirect_to item_path(@item)
    else
      flash[:errors] = "Sorry, something went wrong!"
      redirect_to item_path(@item)
    end
  end

  def index
    @user = current_user
    @loans = Loan.current_user_loans(@user)
  end

  def update
    @loan = Loan.find_by(id: params[:id])
    if @loan.update(loan_params)
      @loan.item.update(available: true)
      flash[:message] = "Item successfully returned!"
      redirect_to user_loans_path(user_id: @loan.user.id)
    else
      flash[:errors] = "Could not return item"
      redirect_to user_loans_path(user_id: params[:id])
    end
  end

  private
  def loan_params
    params.require(:loan).permit(:loan_date, :return_date, :item_id)
  end
end
