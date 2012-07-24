class Transfer
  include Mongoid::Document
  include Mongoid::Timestamps
  
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
      transition from: ['pending', 'failed'], to: 'completed'
    end
  end
end