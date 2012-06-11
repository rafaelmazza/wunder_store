class Variant
  include Mongoid::Document
  
  field :price
  field :count_on_hand, type: Integer
  field :is_master, type: Boolean, default: false
  
  has_and_belongs_to_many :option_values
  
  # mount_uploader :image, ImageUploader
  has_many :images, :autosave => true
  accepts_nested_attributes_for :images
  
  # embedded_in :product
  belongs_to :product
  
  def on_hand=(quantity)
    self.count_on_hand = quantity
  end
  
  def on_hand
    count_on_hand
  end
  
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