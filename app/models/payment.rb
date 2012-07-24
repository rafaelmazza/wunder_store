class Payment
  include Mongoid::Document
  
  field :amount, type: Integer
  
  has_many :transfers
  belongs_to :order
  
  state_machine initial: 'checkout' do
    event :start_processing do
      transition from: ['checkout', 'pending', 'completed', 'processing'], to: 'processing'
    end
    
    event :failure do
      transition from: 'processing', to: 'failed'
    end
    
    event :pend do
      transition from: ['checkout', 'processing'], to: 'pending'
    end
    
    event :complete do
      transition from: ['processing', 'pending', 'checkout'], to: 'completed'
    end
    
    event :cancel do
      transition from: ['completed', 'pending', 'checkout'], to: 'canceled'
    end
  end
  
  def transferred?
    transfers.any? { |t| t.completed? }
  end

  def transfer
    unless transferred?
      @transfer = transfers.create
      response = PAYPAL_EXPRESS_GATEWAY.transfer((amount * 100), order.user.paypal_id)
      if response.success?
        @transfer.complete!
      else
        @transfer.failed!
      end
      @transfer      
    end
  end
end