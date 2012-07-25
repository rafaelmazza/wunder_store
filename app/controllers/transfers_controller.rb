class TransfersController < ApplicationController
  respond_to :html, :json
  
  def index
    @payment = Payment.find(params[:payment_id])
    @transfers = @payment.transfers
  end
  
  def create
    @payment = Payment.find(params[:payment_id])
    @transfer = @payment.transfer
    flash[:notice] = 'Payment successfully transferred' if @transfer.completed?
    respond_with @transfer
  end
end