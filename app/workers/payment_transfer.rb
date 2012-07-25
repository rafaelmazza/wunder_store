class PaymentTransfer
  @queue = :tranfers_queue
  
  def self.perform(transfer_id)
    transfer = Transfer.find(transfer_id)
    response = PAYPAL_EXPRESS_GATEWAY.transfer((transfer.payment.amount * 100), transfer.payment.order.user.paypal_id)
    if response.success?
      transfer.complete!
    else
      transfer.failed!
    end
  end
end