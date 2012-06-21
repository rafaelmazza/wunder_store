require 'spec_helper'

describe OrdersController do
  describe 'POST #create' do
    it 'redirects to edit order path' do
      post :create, order: attributes_for(:order)
      order = Order.last
      response.should redirect_to(edit_order_path(order))
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