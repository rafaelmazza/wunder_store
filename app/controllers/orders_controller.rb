class OrdersController < ApplicationController
  def create
    @order = Order.new(params[:order])
    @order.save
    redirect_to edit_order_path(@order)
  end
  
  def edit
    
  end
end