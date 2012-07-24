class PaymentsController < ApplicationController
  respond_to :html, :json
  
  def index
    # @order = Order.find(params[:order_id])
    @order = current_user.orders.find(params[:order_id])
    @payments = @order.payments
  end
  
  def transfer
    @payment = Payment.find(params[:id])
    
    transfer = @payment.transfer

    respond_with transfer
  end
end