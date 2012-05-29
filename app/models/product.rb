class Product
  include Mongoid::Document
  
  field :name
  field :description
  # field :price, type: Integer
  
  embeds_one :master, :class_name => 'Variant'
  delegate :price, :to => :master
  
  embeds_many :variants
  
  accepts_nested_attributes_for :variants #, :allow_destroy => true
  
  after_initialize :ensure_master
  after_save :save_master
  
  attr_accessible :price, :name, :description
  
  def ensure_master
    self.master ||= Variant.new if new_record?
  end
  
  def save_master
    master.save if master && (master.changed? || master.new_record?)
  end
end
