require 'spec_helper'
require 'active_merchant/billing/gateways/paypal/paypal_express_response'

describe OrdersController do
  describe 'POST #create' do
    let(:user) { create(:user) }
    
    it 'redirects to edit order path' do
      post :create
      order = Order.last
      response.should redirect_to(edit_order_path(order))
    end
    
    it 'associates to user' do
      post :create, order: { user_id: user }
      assigns(:order).user.should == user
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
  
  context 'paypal express checkout' do
    let(:order) { create(:order, line_items: [create(:line_item, price: 100, quantity: 2)]) }
    let(:paypal_redirect_url) { "stub_redirect_url" }
    let(:response) { mock(ActiveMerchant::Billing::PaypalExpressResponse, token: "stub_token", success?: true) }
    let(:details) { stub success?: true, params: {'first_name' => 'Rafael', 'last_name' => 'Mazza'} }

    before do
      PAYPAL_EXPRESS_GATEWAY.stub!(:setup_purchase).and_return(response)
      PAYPAL_EXPRESS_GATEWAY.stub!(:redirect_url_for).and_return(paypal_redirect_url)
      PAYPAL_EXPRESS_GATEWAY.stub(:details_for).and_return(details)
      # PAYPAL_EXPRESS_GATEWAY.stub(:purchase).and_return(mock(success?: true, params: {'first_name' => 'Rafael', 'last_name' => 'Mazza'}))
    end
    
    describe 'GET #checkout' do
      it 'setup paypal purchase' do
        PAYPAL_EXPRESS_GATEWAY.should_receive(:setup_purchase).with((order.total * 100).to_i, {
          money: (order.total * 100).to_i,
          items: [{:name=>"Product 3", :description=>"Amazing product with lot of features", :quantity=>2, :amount=>10000}],
          order_id: order.id.to_s,
          custom: order.id.to_s,
          return_url: confirm_order_url(order),
          cancel_return_url: edit_order_url(order)
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

    describe 'GET #confirm' do
      it 'sets paypal user details' do
        # order.should_receive('fill_with_paypal_details').with('stub_token')
        get :confirm, id: order, token: 'stub_token'
        order = assigns(:order)
        order.token.should == 'stub_token'
        order.first_name.should == 'Rafael'
        order.last_name.should == 'Mazza'
      end
    end
    
    describe 'POST #complete' do
      # let!(:order) { create(:order, line_items: [create(:line_item, price: 100, quantity: 2)], payments: [create(:payment)]) }
      let!(:order) { create(:order, line_items: [create(:line_item, price: 100, quantity: 2)]) }
      
      before do
        PAYPAL_EXPRESS_GATEWAY.stub(:purchase).and_return(response)
        # Order.stub find: order
      end
      
      context 'on success' do
        let(:response) { mock(success?: true, params: {'gross_amount' => (order.total * 100).to_i}) }

        it 'does the purchase and creates a payment' do
          pending
          # p 'payments'
          # p order.payments.inspect
          Order.stub find: order
          PAYPAL_EXPRESS_GATEWAY.should_receive(:purchase).with((order.total * 100).to_i, {token: 'token', payer_id: 'payer_id'})
          order.payments.should_receive(:create).with(amount: response.params['gross_amount'])
          post :complete, id: order, token: 'token', PayerID: 'payer_id'
          p order.payments.inspect
        end
        
        it 'changes payment state to completed' do
          post :complete, id: order, token: 'token', PayerID: 'payer_id'
          payment = Payment.last
          payment.state.should == 'completed'
        end
      end
      
      context 'on failure', current: true do
        let(:response) { mock(success?: false) }
        
        it 'marks payment state as failed' do
          pending
          post :complete, id: order, token: 'token', PayerID: 'payer_id'
          payment = Payment.last
          payment.state.should == 'failed'          
        end
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
  
  describe 'GET #show' do
    let!(:current_user) { as(:user) }
    let(:order) { create(:order, user: current_user) }
    let(:other_user_order) { create(:order, user: create(:user)) }    
    
    it 'assigns order' do
      get :show, id: order
      assigns(:order).should_not be_nil
    end
    
    it 'view only current user order' do
      expect {
        get :show, id: other_user_order
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
  end
end