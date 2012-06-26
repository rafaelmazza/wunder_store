class Address
  include Mongoid::Document
  
  field :address, type: String
  field :city, type: String
  field :state, type: String
  field :zipcode, type: String
  
  embedded_in :order
end