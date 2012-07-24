class TransfersController < ApplicationController
  respond_to :json
  
  def index
    @payment = Payment.find(params[:payment_id])
    @transfers = @payment.transfers
  end
  
  def create
    @payment = Payment.find(params[:payment_id])
    # @transfer = @payment.transfers.create
    Transfer.process(@payment)
    respond_with @transfer
  end
end