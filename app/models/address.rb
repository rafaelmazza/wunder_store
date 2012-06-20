class Address
  include Mongoid::Document
  
  embedded_in :order
end