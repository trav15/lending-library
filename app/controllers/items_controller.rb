class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :redirect_if_not_logged_in!
  before_action :redirect_if_not_authorized!, only: [:edit, :destroy]


  def index
    if params[:user_id]
      @user = User.find_by(params[:used_id])
      @items = @user.items
    else
      @items = Item.where(available: true)
    end
  end

  def new
    @item = Item.new
    @user = current_user
  end

  def create
    @item = Item.create(item_params)
    if @item.save
      flash[:message] = "Item successfully donated! Thank you!"
      redirect_to item_path(@item)
    else
      render :new
    end
  end

  def show
    @lends = Lend.where(item_id: @item.id)
    @lend = current_user.lends.find_or_initialize_by(item: @item, return_date: nil)
  end

  def edit
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
      render :edit
    else
      flash[:errors] = "You are not authorized to edit this item"
      redirect_to item_path(@item)
    end
  end
end
