class Order
  include Mongoid::Document
  
  field :email, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :token, type: String
  
  belongs_to :user

  embeds_one :address
  has_many :line_items, autosave: true
  has_many :payments, dependent: :destroy
  
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
  
  def fill_with_paypal_details(token)
    self.token = token
    paypal_details = PAYPAL_EXPRESS_GATEWAY.details_for(token)
    self.first_name = paypal_details.params['first_name']
    self.last_name = paypal_details.params['last_name']
  end
end