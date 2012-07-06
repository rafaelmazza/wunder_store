class TransfersController < ApplicationController
  respond_to :json
  
  def create
    @payment = Payment.find(params[:payment_id])
    # @transfer = @payment.transfers.create
    Transfer.process(@payment)
    respond_with @transfer
  end
end