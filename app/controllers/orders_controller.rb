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
    # render text: options(@order)
    options = paypal_options(@order)
    response = PAYPAL_EXPRESS_GATEWAY.setup_purchase(options[:money], options)
    
    unless response.success?
      paypal_error(response)
      redirect_to edit_order_url(@order)
      return
    end
    
    redirect_to PAYPAL_EXPRESS_GATEWAY.redirect_url_for(response.token)
  end
  
  def confirm
    @order = Order.find(params[:id])
    options = {token: params[:token], payer_id: params[:PayerID]}
    
    paypal_details = PAYPAL_EXPRESS_GATEWAY.details_for(params[:token])
    if paypal_details.success?
      @order.token = params[:token]
      @order.first_name = paypal_details.params['first_name']
      @order.last_name = paypal_details.params['last_name']
      @order.email = paypal_details.params['payer']
      # @order.payer_id = paypal_details.params['payer_id']
      # @order.payer_country = paypal_details.params['payer_country']
      # @order.payer_status = paypal_details.params['payer_status']
      @order.save
      
      render 'confirm'
    else
      paypal_error(paypal_details)
      redirect_to edit_order_url(@order)
    end
  end
  
  def complete
    @order = Order.find(params[:id])
    options = {token: params[:token], payer_id: params[:PayerID]}
    
    response = PAYPAL_EXPRESS_GATEWAY.purchase((@order.total * 100).to_i, options)

    if response.success?
      # implement states machine
      @order.payments.create(amount: response.params['gross_amount'])
    else
      paypal_error(response)
      redirect_to edit_order_url(@order)
    end
  end
  
  private
  def paypal_options(order)
    items = order.line_items.map do |line_item|
      description = (line_item.variant.product.description or '')[0..120]
      price = (line_item.price * 100).to_i # price in cents
      { name: line_item.variant.product.name,
        description: description,
        quantity: line_item.quantity,
        amount: price }
    end
    
    opts = {
      return_url: confirm_order_url(order),
      cancel_return_url: edit_order_url(order),
      order_id: order.id.to_s,
      custom: order.id.to_s,
      items: items,
      money: (order.total * 100).to_i
    }
    opts
  end
  
  def paypal_error(response)
    error = response.params[:message] ||
            response.params[:response_reason_text] ||
            response.message
    error_message = "#{I18n.t('gateway_error')} ... #{error}"
    logger.error(error_message)          
    flash[:alert] = error_message
  end
end