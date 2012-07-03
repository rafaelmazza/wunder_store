class OrdersController < ApplicationController
  def index
    @orders = current_user.orders.all
  end
  
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
  
  def show
    @order = current_user.orders.find(params[:id])
  end
  
  def edit
    @order = Order.find(params[:id])
  end
  
  def checkout
    @order = Order.find(params[:id])
    response = PAYPAL_EXPRESS_GATEWAY.setup_purchase(@order.total * 100, # order total in cents
      ip: request.remote_ip,
      description: 'Wunder Store',
      # items: [{:name => "Tickets", :quantity => 22, :description => "Tickets for 232323", :amount => 10}],
      return_url: complete_order_url(@order),
      cancel_return_url: request.env['HTTP_REFERER']
    )
    redirect_to PAYPAL_EXPRESS_GATEWAY.redirect_url_for(response.token)
  end
  
  def complete
    @order = Order.find(params[:id])
    render text: PAYPAL_EXPRESS_GATEWAY.purchase(@order.total * 100, {token: params[:token], payer_id: params[:PayerID]}).inspect
    # @order.fill_with_paypal_details(params[:token])
    # @order.save # TODO: refactor
  end
end