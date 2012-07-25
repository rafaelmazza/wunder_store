class TransfersController < ApplicationController
  respond_to :html, :json
  
  def index
    @payment = Payment.find(params[:payment_id])
    @transfers = @payment.transfers
  end
  
  def create
    @payment = Payment.find(params[:payment_id])
    @transfer = @payment.transfers.create
    Resque.enqueue(PaymentTransfer, @transfer.id)
    # @transfer = @payment.transferred
    flash[:notice] = 'Your payment is being processed.'
    respond_with @transfer
  end
  
  def show
    @transfer = Transfer.find(params[:id])
  end
end