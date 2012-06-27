require 'spec_helper'

describe Order do
  it { should belong_to :user }
  it { should have_field(:email).of_type(String) }
  it { should have_field(:first_name).of_type(String) }
  it { should have_field(:last_name).of_type(String) }
  it { should embed_one :address }
  it { should have_many :line_items }
  
  describe '#total' do
    let(:order) { Order.new(line_items: [create(:line_item, quantity: 1, variant: create(:variant, price: 50)), create(:line_item, quantity: 2, variant: create(:variant, price: 50))]) }
    
    it 'returns order total price' do
      order.total.should == 150
    end
  end
  
  describe '#add_variant' do
    let(:order) { Order.new }
    let(:product) { create(:product, price: 10) }
    
    it 'updates order total' do
      order.total.should == 0
      order.add_variant(product.master, 2)
      order.total.should == 20
    end
    
    it 'sets default quantity to 1 if not defined' do
      line_item = order.add_variant(product.master)
      line_item.quantity.should == 1
    end
    
    it 'increase line item quantity if present' do
      2.times { order.add_variant(product.master) }
      order.line_items.length.should == 1
      order.find_line_item_by_variant(product.master).quantity.should == 2
    end
  end
end