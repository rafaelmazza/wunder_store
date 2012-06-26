class OrdersController < ApplicationController
  def create
    @order = Order.new(params[:order])
    
    params[:variants].each do |variant_id, quantity|
      variant = Variant.find(variant_id)
      quantity = quantity.to_i
      @order.add_variant(variant, quantity) if quantity > 0
    end if params[:variants]
    
    @order.save
    redirect_to edit_order_path(@order)
  end
  
  def edit
    @order = Order.find(params[:id])
  end
end