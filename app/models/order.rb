class Order
  include Mongoid::Document
  
  field :quantity, type: Integer
  
  belongs_to :user

  embeds_one :address
end