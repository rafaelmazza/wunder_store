class OptionType
  include Mongoid::Document
  
  field :name
  
  has_and_belongs_to_many :products
  
  # embeds_many :option_values
  has_many :option_values, :autosave => true
  
  accepts_nested_attributes_for :option_values
end