require 'spec_helper'

describe Product do
  let(:product) { create(:product) }
  
  it 'creates master after initialize' do
    product.master.should_not be_nil
  end
  
  context '#variants_including_master' do
    # let(:product) { create(:product) }

    it "includes master" do
      product.variants_including_master.should include(product.master)
    end
  end

  context '#variants' do
    # let(:product) { create(:product) }

    it "does not include master variant" do
      product.variants.should_not include(product.master)
    end
  end

  context '#on_hand' do
    # let(:product) { create(:product) }
    
    context 'with no variants' do
      before do
        product.master.stub on_hand: 2
      end
  
      it 'returns the correct number of products on hand' do
        product.on_hand.should == 2
      end
    end
    
    context 'with many variants' do
      # let!(:variant_1) {create(:variant, on_hand: 100, product: product)}
      # let!(:variant_2) {create(:variant, on_hand: 100, product: product)}
      
      before do
        # product.stub :variants => [double(:variant, on_hand: 100, product: product), double(:variant, on_hand: 100, product: product)]
        product.stub :variants => [double(:variant, on_hand: 100), double(:variant, on_hand: 100)]
        # product.variants.should_receive('exists?').and_return true
        product.variants.stub 'exists?' => true
      end
      
      it 'returns the correct number of products on hand' do
        product.on_hand.should == 200
      end
    end
  end
end
