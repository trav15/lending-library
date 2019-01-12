class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :redirect_if_not_logged_in!
  before_action :redirect_if_not_authorized!, only: [:edit, :destroy]


  def index
    @items = Item.where(available: true)
    @borrowed = Item.where(available: false)
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
      render :news
    end
  end

  def show
    if !@item
      flash[:errors] = "Item not found"
      redirect_to items_path
    else
      set_item
      @lends = Lend.where(item_id: @item.id)
      @lend = current_user.lends.find_or_initialize_by(item: @item, return_date: nil)
      @user = current_user
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
