require 'spec_helper'

describe LineItem do
  it { should belong_to :order }
  it { should belong_to :variant }
  
  it { should have_field(:quantity).of_type(Integer) }
  it { should have_field(:price).of_type(Float) }
  
  let(:line_item) { LineItem.create(quantity: 3, variant: create(:variant, price: 50)) }
  
  before do
    # line_item.stub variant: variant, new_record?: false
  end

  context 'initialization' do    
    it 'copy variant price' do
      line_item.should_receive(:copy_price)
      line_item.save
      line_item.price.should == 50
    end
  end
  
  describe '#total' do
    it 'returns total price for the item' do
      line_item.total.should == 150
    end
  end
end