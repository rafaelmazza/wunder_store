require 'spec_helper'
require 'active_merchant/billing/gateways/paypal/paypal_express_response'

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
  
  describe 'GET #checkout' do
    let(:paypal_redirect_url) { "banana" }
    let(:response) { mock(ActiveMerchant::Billing::PaypalExpressResponse, token: "stub_token") }
    
    before(:each) do
      PAYPAL_EXPRESS_GATEWAY.stub!(:setup_purchase).and_return(response)
      PAYPAL_EXPRESS_GATEWAY.stub!(:redirect_url_for).and_return(paypal_redirect_url)
    end
    
    it 'get' do
      PAYPAL_EXPRESS_GATEWAY.should_receive(:setup_purchase).with(123456, {
        ip: request.remote_ip,
        return_url: products_url,
        cancel_return_url: products_url
      }).and_return(response)
      get :checkout
    end
  end
end