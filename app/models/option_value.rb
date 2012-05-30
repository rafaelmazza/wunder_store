class OptionValue
  include Mongoid::Document
  
  field :name
  
  has_and_belongs_to_many :variants
  
  # embedded_in :option_type
  belongs_to :option_type
end