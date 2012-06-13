require 'spec_helper'

describe Product do
  let(:product) { create(:product) }
  
  it { should belong_to :user }
  
  it 'creates master after initialize' do
    product.master.should_not be_nil
  end
  
  def build_option_type_with_values(name, values)
    ot = create(:option_type, name: name)
    values.each do |v|
      ot.option_values.create({name: v})
    end
    ot
  end
  
  context '#create', current: true do
    let(:product) { build(:product) }

    # it 'creates option types, values and variants from option values hash with multiple option types' do
    #   # option_values_hash = [{name: 'color', values: [{name: 'black', count_on_hand: 10}, {name: 'blue', count_on_hand: 5}, {name: 'red', count_on_hand: 20}]}]
    #   option_values_hash = [
    #     {name: 'color', values: [{name: 'black', count_on_hand: 10}, {name: 'blue', count_on_hand: 5}, {name: 'red', count_on_hand: 20}]},
    #     {name: 'size', values: [{name: 'P', count_on_hand: 20}, {name: 'M', count_on_hand: 50}, {name: 'G', count_on_hand: 10}]}
    #   ]
    #   product.option_values_hash = option_values_hash
    #   product.save
    #   product.option_type_ids.length.should == 2
    #   product.variants.length.should == 9
    # end
    
    # it 'creates option types, values and variants from option values hash with multiple option types' do
    #   option_values_hash = [{name: 'color', values: [{name: 'black', count_on_hand: 10}, {name: 'blue', count_on_hand: 5}, {name: 'red', count_on_hand: 20}]}]
    #   product.option_values_hash = option_values_hash
    #   product.save
    #   product.option_type_ids.length.should == 1
    #   product.variants.length.should == 3
    # end
    
    it 'creates variants from option values hash with multiple option types' do
      color = build_option_type_with_values('color', %w(White Black Blue))
      size = build_option_type_with_values('size', %w(P M G))
      option_values_hash = {}
      option_values_hash[color.id.to_s] = color.option_values.map(&:id)
      option_values_hash[size.id.to_s] = size.option_values.map(&:id)
      product.option_values_hash = option_values_hash
      product.save
      product.option_type_ids.length.should == 2
      product.variants.length.should == 9
    end
    
    # let(:option_values_hash) do
    #   hash = {}
    #   hash[:color] = %w(black white blue)
    #   hash[:size] = %w(P M G)
    #   hash
    # end
    
    # let(:option_values_hash) do
    #   hash = {}
    #   # hash[:color] = [[name: 'black', count_on_hand: 10], [name: 'blue', count_on_hand: 5], [name: 'red', count_on_hand: 5]]
    #   hash[:color] = [{name: 'black', count_on_hand: 10}, {name: 'black', count_on_hand: 10}]
    #   # hash[:size] = [[name: 'P', count_on_hand: 5], [name: 'M', count_on_hand: 5], [name: 'G', count_on_hand: 5]]
    #   hash
    # end    
    
    # it 'creates option types, values and variants from option values hash with multiple option types' do
    #   option_values_hash = [{name: 'color', values: [{name: 'black', count_on_hand: 10}, {name: 'blue', count_on_hand: 5}, {name: 'red', count_on_hand: 20}]}]
    #   # p option_values_hash[0][:values].length
    #   hash = {}
    #   option_values_hash.each do |name, values|
    #     ot = build_option_type_with_values(name, values)
    #     hash[ot.id.to_s] = ot.option_values.map(&:id)
    #   end
    #   p hash
    #   product.option_values_hash = hash
    #   product.save
    #   product.option_type_ids.length.should == 1
    #   product.variants.length.should == 3
    # end
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
