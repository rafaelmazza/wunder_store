require 'spec_helper'

describe OrdersController do
  let(:order) { build(:order) }
  
  describe 'POST #create' do
    it 'redirects to edit order path' do
      post :create, order: order
      order = Order.last
      response.should redirect_to(edit_order_path(order))
    end
  end
end