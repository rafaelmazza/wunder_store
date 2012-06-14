require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  describe 'as guest' do
    before do
      @ability = Ability.new(nil)
    end
    
    it 'can view a product' do
      @ability.should be_able_to(:show, :products)
    end
  end
  
  describe 'as user' do
    before do
      @user = create(:user)
      @ability = Ability.new(@user)
    end
    
    it 'create a product' do
      @ability.should be_able_to(:create, :products)
    end
  end
end
