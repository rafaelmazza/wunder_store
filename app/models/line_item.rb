class LineItem
  include Mongoid::Document
  
  field :quantity, type: Integer
  field :price, type: Float
  
  # embedded_in :order
  belongs_to :order
  belongs_to :variant
  
  # validate :price, presence: true
  
  before_validation :copy_price
  
  def copy_price
    self.price = variant.price if variant && price.nil?
  end
  
  def total
    quantity * price
  end
end