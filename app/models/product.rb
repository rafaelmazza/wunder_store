require 'wunder_store' # TODO: change require location

class Product
  include Mongoid::Document
  
  belongs_to :user
  
  field :name
  field :description
  field :theme
  
  has_and_belongs_to_many :option_types, :autosave => true
  # has_many :option_types
  # embeds_many :option_types
  
  # embeds_one :master, :class_name => 'Variant'
  has_one :master, :class_name => 'Variant', :autosave => true
  delegate_belongs_to :master, :price
  # delegate_belongs_to :master, :images
  
  # embeds_many :variants
  has_many :variants_including_master, :autosave => true, :class_name => 'Variant'
  
  accepts_nested_attributes_for :master
  accepts_nested_attributes_for :variants #, :allow_destroy => true
  # accepts_nested_attributes_for :option_types
  
  after_initialize :ensure_master
  after_save :save_master
  
  # after_save :build_variants
  after_create :build_variants_from_option_values_hash, :if => :option_values_hash
  
  attr_accessor :option_values_hash
  
  def variants
    variants_including_master.where(is_master: false)
  end
  
  def ensure_master
    self.master ||= Variant.new if new_record?
    self.master.is_master = true
  end
  
  def save_master
    master.save if master && (master.changed? || master.new_record?)
  end
  
  def on_hand
    variants.exists? ? variants.inject(0) { |sum, v| sum + v.on_hand } : master.on_hand
  end
  
  private
    # def ensure_option_types_exist_for_values_hash
    #   return if option_values_hash.nil?
    #   hash = {}
    #   option_values_hash.each do |o|
    #     ot = option_types.create({name: o[:name]})
    #     hash[ot.id.to_s] = []
    #     o[:values].each do |v|
    #       ov = ot.option_values.create({name: v[:name]})
    #       hash[ot.id.to_s].push({option_value_ids: [ov.id], count_on_hand: v[:count_on_hand]})
    #     end
    #   end
    #   self.option_values_hash = hash
    #   # option_values_hash.keys.each do |id|
    #   #   self.option_type_ids << id unless option_type_ids.include?(id)
    #   # end
    # end
    # 
    # def build_variants_from_option_values_hash
    #   ensure_option_types_exist_for_values_hash
    #   option_values_hash.values.each do |v|
    #     v.each do |h|
    #       variant = variants.create(h)
    #     end
    #   end
    #   save
    #   # values = option_values_hash.values
    #   # p values
    #   # values = values.inject(values.shift) { |memo, value| memo.product(value).map(&:flatten) }
    #   # 
    #   # values.each do |ids|
    #   #   variant = variants.create({:option_value_ids => ids, :price => master.price})
    #   # end
    #   # save
    # end
    
    def ensure_option_types_exist_for_values_hash
      return if option_values_hash.nil?
      option_values_hash.keys.each do |id|
        self.option_type_ids << id unless option_type_ids.include?(id)
      end
    end
    
    def build_variants_from_option_values_hash
      ensure_option_types_exist_for_values_hash
      values = option_values_hash.values
      values = values.inject(values.shift) { |memo, value| memo.product(value).map(&:flatten) }
    
      values.each do |ids|
        variant = variants.create({:option_value_ids => ids, :price => master.price})
      end
      save
    end    
    
    def build_variants
      option_types.each do |option_type|
        option_type.option_values.each do |ov|
          variants.create({:option_value_ids => [ov.id], :price => master.price}, :without_protection => true) unless variants.map(&:option_value_ids).flatten.include?(ov.id)
        end        
      end
    end
end
