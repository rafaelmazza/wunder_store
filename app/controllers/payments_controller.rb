class PaymentsController < ApplicationController
  def index
    @order = Order.find(params[:order_id])
    @payments = @order.payments
  end
  
  def transfer
    @payment = Payment.find(params[:id])
    @transfer = @payment.transfers.create
        
    response = PAYPAL_EXPRESS_GATEWAY.transfer([(@payment.amount * 100), 'john_1336691024_per@cafeazul.com.br'])
    # response = PAYPAL_EXPRESS_GATEWAY.transfer([(@payment.amount * 100), 'john'])
    if response.success?
      @transfer.complete!
    else
      @transfer.failed!
    end
    
    # render nothing: true
    render text: response.inspect
  end
end