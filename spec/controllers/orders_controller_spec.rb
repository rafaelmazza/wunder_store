require 'spec_helper'

describe OrdersController do
  describe 'POST #create' do
    it 'redirects to edit order path' do
      post :create
      order = Order.last
      response.should redirect_to(edit_order_path(order))
    end
    
    context 'with variants' do
      let(:order) { mock_model(Order) }
      # let(:variant) { mock_model(Variant) }
      let(:variant) { create(:variant) }
      
      before do
        order.stub save: true
        Order.should_receive(:new).and_return(order)        
      end
      
      it 'creates order with variant and quantity' do
        order.should_receive(:add_variant).with(variant, 1)
        post :create, variants: {variant.id => 1}
      end
      
    end
  end
  
  describe 'GET #edit' do
    let(:order) { create(:order) }
    
    it 'assigns recently created order to edit action' do
      get :edit, id: order
      assigns(:order).should == order
    end
  end
end