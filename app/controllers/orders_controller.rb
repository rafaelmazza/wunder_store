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
  
  def checkout
    # @order = Order.find(params[:id])
    # render text: @order.inspect
    response = PAYPAL_EXPRESS_GATEWAY.setup_purchase(220, # order total in cents
      ip: request.remote_ip,
      items: [{:name => "Tickets", :quantity => 22, :description => "Tickets for 232323", :amount => 10}],
      return_url: callback_order_url,
      cancel_return_url: products_url
    )
    # render text: response.inspect
    redirect_to PAYPAL_EXPRESS_GATEWAY.redirect_url_for(response.token)
  end
  
  def callback
    details = PAYPAL_EXPRESS_GATEWAY.details_for(params[:token])
    render text: details.params.inspect
  end
end