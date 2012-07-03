require 'spec_helper'

describe PaymentNotification do
  it { should belong_to(:order) }
  
  describe '.create' do
    let(:params) {{"test_ipn"=>"1", "payment_type"=>"instant", "payment_date"=>"07:08:03 Jul 03, 2012 PDT", "payment_status"=>"Completed", "address_status"=>"confirmed", "payer_status"=>"verified", "first_name"=>"John", "last_name"=>"Smith", "payer_email"=>"buyer@paypalsandbox.com", "payer_id"=>"TESTBUYERID01", "address_name"=>"John Smith", "address_country"=>"United States", "address_country_code"=>"US", "address_zip"=>"95131", "address_state"=>"CA", "address_city"=>"San Jose", "address_street"=>"123, any street", "business"=>"seller@paypalsandbox.com", "receiver_email"=>"seller@paypalsandbox.com", "receiver_id"=>"TESTSELLERID1", "residence_country"=>"US", "item_name"=>"something", "item_number"=>"AK-1234", "quantity"=>"1", "shipping"=>"3.04", "tax"=>"2.02", "mc_currency"=>"USD", "mc_fee"=>"0.44", "mc_gross"=>"12.34", "txn_type"=>"web_accept", "txn_id"=>"373148", "notify_version"=>"2.1", "custom"=>"xyz123", "invoice"=>"abc1234", "charset"=>"windows-1252", "verify_sign"=>"A7wT05LI8DaQ2aQh4zwERCXTKaAOALoLBaR2HkDn44xdnLDvfPlgOKzR"}}
    
    it 'saves params and status' do
      payment_notification = PaymentNotification.create(params: params, status: params['payment_status'])
      payment_notification.params.should == params
      payment_notification.status.should == "Completed"
    end
  end
end