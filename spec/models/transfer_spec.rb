require 'spec_helper'

describe Transfer do
  it { should be_a(Mongoid::Document) }
  it { should belong_to(:payment) }
  
  describe '.process' do
    let(:transfer) { Transfer.new }
    let(:payment) { create(:payment) }
    context 'on success' do
      before do
        PAYPAL_EXPRESS_GATEWAY.stub transfer: mock(success?: true)
      end
      
      it 'changes transfer state to complete' do
        # PAYPAL_EXPRESS_GATEWAY.should_receive(:transfer).with([payment.amount, 'email'], subject: 'subject', note: 'note')
        PAYPAL_EXPRESS_GATEWAY.should_receive(:transfer).with([payment.amount, 'email'])
        Transfer.process(payment)
        transfer.state.should == 'complete'
      end
    end
  end
end