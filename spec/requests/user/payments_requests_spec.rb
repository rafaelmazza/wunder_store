require 'spec_helper'

describe 'Payments Requests' do
  let!(:current_user) { create_logged_in_user }  
  let!(:order) { create(:order, user: current_user) }
  let!(:payment) { create(:payment, order: order) }
  
  before do
    PAYPAL_EXPRESS_GATEWAY.stub transfer: response
  end
  
  let(:response) { mock(success?: true) }
  
  it 'transfers payment amount to user paypal account' do
    visit order_payments_path(order)
    click_on 'Transfer'
    page.should have_content 'Payment successfully transferred'
  end
end