require 'spec_helper'

describe TransfersController do
  let(:current_user) { create_logged_in_user }
  let(:payment) { create(:payment) }
  
  before do
    PAYPAL_EXPRESS_GATEWAY.stub(:transfer).and_return(response)
  end
  
  context 'successfull transfer' do
    let(:response) { mock(success?: true) }
    
    describe 'post #create' do
      it 'transfers payment to paypal account' do
        post :create, payment_id: payment
      end
    end    
  end
end