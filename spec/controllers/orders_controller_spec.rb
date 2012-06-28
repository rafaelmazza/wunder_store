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
  
  context 'paypal express checkout', current: true do
    let(:order) { create(:order, line_items: [create(:line_item, price: 100, quantity: 2)]) }
    let(:paypal_redirect_url) { "stub_redirect_url" }
    let(:response) { mock(ActiveMerchant::Billing::PaypalExpressResponse, token: "stub_token") }
    let(:details) { stub params: {'first_name' => 'Rafael', 'last_name' => 'Mazza'} }

    before do
      PAYPAL_EXPRESS_GATEWAY.stub!(:setup_purchase).and_return(response)
      PAYPAL_EXPRESS_GATEWAY.stub!(:redirect_url_for).and_return(paypal_redirect_url)
      PAYPAL_EXPRESS_GATEWAY.stub(:details_for).and_return(details)
    end
    
    describe 'GET #checkout' do
      it 'setup paypal purchase' do
        PAYPAL_EXPRESS_GATEWAY.should_receive(:setup_purchase).with(order.total * 100, {
          description: 'Wunder Store',
          # items: [{:name => "Tickets", :quantity => 22, :description => "Tickets for 232323", :amount => 10}],
          ip: request.remote_ip,
          return_url: complete_order_url(order),
          cancel_return_url: request.env['HTTP_REFERER']
        }).and_return(response)
        get :checkout, id: order
      end

      it 'asks for the redirect url' do
        PAYPAL_EXPRESS_GATEWAY.should_receive(:redirect_url_for).with("stub_token").and_return(paypal_redirect_url)
        get :checkout, id: order
      end

      it 'redirects to paypal gateway' do
        get :checkout, id: order
        response.should redirect_to(paypal_redirect_url)
      end
    end

    describe 'GET #complete' do
      it 'sets paypal user details' do
        # order.should_receive('fill_with_paypal_details').with('stub_token')
        get :complete, id: order, token: 'stub_token'
        order = assigns(:order)
        order.token.should == 'stub_token'
        order.first_name.should == 'Rafael'
        order.last_name.should == 'Mazza'
      end
    end
  end
  
  describe 'GET #index' do
    let(:current_user) { as(:user) }    
    let!(:orders) { [create(:order, user: current_user), create(:order, user: current_user)] }
    let(:other_user_order) { create(:order, user: create(:user)) }
    
    it 'assigns current user orders' do
      get :index
      assigns(:orders).should == orders
      assigns(:orders).should_not include(other_user_order)
    end
  end
end