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
    @order = Order.find(params[:id])
    # render text: @order.total * 100
    response = PAYPAL_EXPRESS_GATEWAY.setup_purchase(@order.total * 100, # order total in cents
      ip: request.remote_ip,
      description: 'Wunder Store',
      # items: [{:name => "Tickets", :quantity => 22, :description => "Tickets for 232323", :amount => 10}],
      return_url: complete_order_url(@order),
      cancel_return_url: request.env['HTTP_REFERER']
    )
    # render text: response.inspect
    redirect_to PAYPAL_EXPRESS_GATEWAY.redirect_url_for(response.token)
  end
  
  def complete
    @order = Order.find(params[:id])
    @order.fill_with_paypal_details(params[:token])
    # render text: @order.first_name.inspect
    # render text: details.params.inspect
  end
end