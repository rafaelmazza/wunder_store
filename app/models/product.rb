class Product
  include Mongoid::Document
  
  field :name
  field :description
  field :price, type: Integer
end
