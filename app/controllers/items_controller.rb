class ItemsController < ApplicationController
  def index
  end

  def new
    @item = Item.new
  end

  def create
  end

  def show
    @item = Item.find(params[:id]) 
    @first_photo = @item.photos[0]
    @second_photo = @item.photos[1]
    @third_photo = @item.photos[2]
    @seller_address = @item.seller.addresses[0]
  end

  def edit
  end

  def destroy
  end

  def update
  end

  def confirm
  end
end
