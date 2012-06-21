class Order
  include Mongoid::Document
  
  field :quantity, type: Integer
  
  belongs_to :user

  embeds_one :address
  has_many :line_items
  
  def total
    100
  end
end