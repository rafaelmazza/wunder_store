class Order
  include Mongoid::Document
  
  field :email, type: String
  field :first_name, type: String
  field :last_name, type: String
  
  belongs_to :user

  embeds_one :address
  has_many :line_items, autosave: true
  
  def total
    line_items.map(&:total).sum
  end
  
  def add_variant(variant, quantity=1)
    current_item = find_line_item_by_variant(variant)
    if current_item
      current_item.quantity += quantity
      current_item.save
    else
      current_item = LineItem.new(quantity: quantity)
      current_item.variant = variant
      current_item.price = variant.price
      self.line_items << current_item
    end
    current_item
  end
  
  def find_line_item_by_variant(variant)
    line_items.detect { |line_item| line_item.variant_id == variant.id }
  end
end