class Variant
  include Mongoid::Document
  
  field :price
  
  has_and_belongs_to_many :option_values
  
  # embedded_in :product
  belongs_to :product
end