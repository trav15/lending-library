class LoansController < ApplicationController
  def new
    @loan = Loan.new
    @item = Item.find_by(id: params[:item_id])
    if !@item
      flash[:errors] = "Item not found"
      redirect_to items_path
    elsif @item.available == false
      flash[:errors] = "Item not available to borrow"
      redirect_to items_path
    end
  end

  def create
    @item = Item.find_by(id: params[:loan][:item_id])
    @loan = current_user.loans.find_or_initialize_by(item_id: params[:item_id], return_date: nil)
    @loan.update(loan_params)
    if @loan.save
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
    @loan = Loan.find_by(id: params[:loan][:id])
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
    params.require(:loan).permit(:loan_date, :return_date, :item_id, :used_for)
  end
end
