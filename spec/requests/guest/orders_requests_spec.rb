require 'spec_helper'
require 'active_merchant/billing/gateways/paypal/paypal_express_response'

describe 'Guest orders requests' do
  let(:user) { create(:user) }
  let(:product) { create(:product, :price => 100, user: user) }
  
  let(:paypal_redirect_url) { "/stub_redirect_url" }
  let(:response) { mock(ActiveMerchant::Billing::PaypalExpressResponse, success?: true, token: "stub_token") }
  let(:details) { stub success?: true, params: {'first_name' => 'Rafael', 'last_name' => 'Mazza'} }
  
  before(:each) do
    PAYPAL_EXPRESS_GATEWAY.stub!(:setup_purchase).and_return(response)
    # PAYPAL_EXPRESS_GATEWAY.stub!(:redirect_url_for).and_return(paypal_redirect_url)
    PAYPAL_EXPRESS_GATEWAY.stub!(:details_for).and_return(details)
  end  

  it 'create an order' do
    visit product_path(product)
    fill_in 'quantity', with: 2
    click_on 'Buy'
    
    order = Order.first
    current_path.should == edit_order_path(order)
    find('.order-price').should have_content(200)
    
    # fill_in 'Email', with: 'rafael@cafeazul.com.br'
    # fill_in 'First name', with: 'Rafael'
    # fill_in 'Last name', with: 'Mazza'
    # fill_in 'Address', with: 'Av. Moema 170, conjunto 65'
    # fill_in 'City', with: 'Sao Paulo'
    # fill_in 'State', with: 'Sao Paulo'
    # fill_in 'Zipcode', with: '04077-020'
    # fill_in 'Phone', with: '55 11 5052-7001'
    # select 'Brazil', from: 'Country'
    
    PAYPAL_EXPRESS_GATEWAY.stub!(:redirect_url_for).and_return(complete_order_url(order))
    
    click_on 'Checkout'
    current_path.should == complete_order_path(order)
    page.should have_content('Order completed')
    find('.total').should have_content(order.total)
    find('.first-name').should have_content(order.first_name)
    find('.last-name').should have_content(order.last_name)
  end
end