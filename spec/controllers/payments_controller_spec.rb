require 'spec_helper'

describe PaymentsController do
  let(:payment) { create(:payment) }
  
  describe 'GET #transfer' do
    it 'transfers payment to paypal account' do
      # Transfer.should_receive(:create).with(amount: payment.amount)
      get :transfer, id: payment
    end
  end
end