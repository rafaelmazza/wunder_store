# require 'carrierwave/mongoid'

class Variant
  include Mongoid::Document
  
  field :price
  
  has_and_belongs_to_many :option_values
  
  mount_uploader :image, ImageUploader
  
  # embedded_in :product
  belongs_to :product
  
  def options_text
    values = self.option_values

    # values = 
    # values.map! do |ov|
    #   "#{ov.option_type.name}: #{ov.name}"
    #   # p "#{ov.option_type.name}: #{ov.name}"
    # end
    
    values = values.map! { |ov| "#{ov.option_type.name}: #{ov.name}" }    
    
    # p values.to_sentence({:words_connector => ", ", :two_words_connector => ", "})
    # p values
    values.to_sentence({:words_connector => ", ", :two_words_connector => ", "})
  end
end