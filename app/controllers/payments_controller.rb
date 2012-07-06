class PaymentsController < ApplicationController
  def transfer
    @payment = Payment.find(params[:id])
    Payment.transfer(@payment)
    render nothing: true
  end
end