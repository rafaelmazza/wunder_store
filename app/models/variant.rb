class Variant
  include Mongoid::Document
  
  field :price
  
  embedded_in :product
end