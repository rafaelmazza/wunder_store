require 'spec_helper'

describe Order do
  it { should belong_to :user }
  it { should have_field(:quantity).of_type(Integer) }
  it { should embed_one :address }
  it { should have_many :line_items }
  
  let(:order) { Order.new(line_items: [create(:line_item), create(:line_item)]) }
  # let(:order) { Order.new }
  
  describe '#total' do
    it 'returns order total price according to line item sum' do
      # p LineItem.new
      # p create(:line_item)
      # order.line_items = [create(:line_item), create(:line_item)]
      order.total.should == 100
    end
  end
end