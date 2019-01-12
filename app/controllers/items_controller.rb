class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
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
    @lend = current_user.lends.find_or_initialize_by(item: @item, return_date: nil)
  end

  def edit
    if @item.user = current_user
    else
      redirect_to '/items'
    end
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
    if @item.user != current_user
      redirect_to '/items'
    else
      redirect_to '/edit'
    end
  end
end
