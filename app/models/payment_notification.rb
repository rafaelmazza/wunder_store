class PaymentNotification
  include Mongoid::Document
  
  belongs_to :order
end