class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :next]
  before_action :redirect_if_not_logged_in!
  before_action :redirect_if_not_authorized!, only: [:edit, :destroy]


  def index
    @items = Item.is_available
    @borrowed = Item.is_borrowed
    @user = current_user
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @items}
    end
  end

  def new
    @item = Item.new
    @user = current_user
  end

  def create
    @item = Item.create(item_params)
    if @item.save
      respond_to do |format|
        format.json { render json: @item, status: 201 }
        format.html { flash[:message] = "Item successfully donated! Thank you!"
        redirect_to item_path(@item) }
      end
    else
      render :new
    end
  end

  def next
    @next_item = @item.next
    @loans = Loan.item_loans(@next_item)
    render :json => {:item => @next_item,
                                :user => @user,
                                :loans => @loans }
  end

  def show
    if !@item
      flash[:errors] = "Item not found"
      redirect_to items_path
    else
      @loans = Loan.item_loans(@item)
      @loan = current_user.loans.find_or_initialize_by(item: @item, return_date: nil)
      @loaner = @loans.current_loan
      @item.donor_id = current_user.id
      respond_to do |format|
        format.html { render :index }
        format.json { render json: @item.to_json(:except => [:created_at, :updated_at], include: [:loans,
          users: { only: [:id, :username]}])
        }
      end
    end
  end

  def edit
    render :edit
  end

  def update
    if @item.update(item_params)
      flash[:message] = "Item successfully updated!"
      redirect_to item_path(@item)
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    flash[:message] = "Item successfully removed!"
    redirect_to items_path
  end

  def stats
    @items = Item.by_popularity.reverse
  end

  private
  def item_params
    params.require(:item).permit(:name, :created_at, :available, :donor_id)
  end

  def set_item
    @item = Item.find_by(id: params[:id])
  end

  def redirect_if_not_authorized!
    if @item.donor_id == current_user.id
      @user = current_user
    else
      flash[:errors] = "You are not authorized to edit this item"
      redirect_to item_path(@item)
    end
  end
end
