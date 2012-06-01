require 'wunder_store' # TODO: change require location

class Product
  include Mongoid::Document
  
  field :name
  field :description
  # field :price, type: Integer
  
  has_and_belongs_to_many :option_types, :autosave => true
  # has_many :option_types
  # embeds_many :option_types
  
  # embeds_one :master, :class_name => 'Variant'
  has_one :master, :class_name => 'Variant'
  delegate_belongs_to :master, :price
  
  # embeds_many :variants
  has_many :variants
  
  accepts_nested_attributes_for :variants #, :allow_destroy => true
  accepts_nested_attributes_for :option_types
  
  after_initialize :ensure_master
  after_save :save_master
  
  after_save :build_variants
  
  def ensure_master
    self.master ||= Variant.new if new_record?
  end
  
  def save_master
    master.save if master && (master.changed? || master.new_record?)
  end
  
  private
  
    def build_variants
      option_types.each do |option_type|
        option_type.option_values.each do |ov|
          variants.create({:option_value_ids => [ov.id], :price => master.price}, :without_protection => true)
        end        
      end
    end
end
