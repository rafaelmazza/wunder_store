class CompletedTransferNotification
  @queue = :completed_transfers_notifications_queue
  
  def self.perform
    TransferNotifier.completed.deliver
  end
end