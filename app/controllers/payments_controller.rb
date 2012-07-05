class PaymentsController < ApplicationController
  def transfer
    @payment = Payment.find(params[:id])
    render nothing: true
  end
end