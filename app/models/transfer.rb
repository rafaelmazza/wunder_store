class Transfer
  include Mongoid::Document
  
  belongs_to :payment
  
  scope :pending, where(state: 'pending')
  
  state_machine initial: 'pending' do
    event :pending do
      transition from: ['failed', 'pending'], to: 'pending'
    end
    
    event :failed do
      transition from: ['pending', 'failed'], to: 'failed'
    end
    
    event :complete do
      transition from: ['pending', 'failed'], to: 'complete'
    end
  end
  
  def self.process(payment)
    response = PAYPAL_EXPRESS_GATEWAY.transfer([payment.amount, 'email'])
  end
end