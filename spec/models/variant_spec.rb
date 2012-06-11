require 'spec_helper'

describe Variant do
  let(:variant) { create(:variant) }
  
  describe 'on_hand=' do
    it 'should change count_on_hand value' do
      variant.on_hand = 100
      variant.count_on_hand.should == 100
    end
  end
end