require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  describe 'as guest' do
    before do
      @ability = Ability.new(nil)
    end
    
    it 'can view a product' do
      @ability.should be_able_to(:show, Product)
    end
  end
  
  describe 'as user' do
    before do
      @user = create(:user)
      @ability = Ability.new(@user)
    end
    
    it 'can create, view, list and update a product' do
      @ability.should be_able_to(:create, Product)
      @ability.should be_able_to(:show, Product)
      @ability.should be_able_to(:index, :products)
      @ability.should be_able_to(:destroy, Product)
    end
  end
end
