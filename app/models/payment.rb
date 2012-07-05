class Payment
  include Mongoid::Document
  
  belongs_to :order
end