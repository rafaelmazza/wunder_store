require 'spec_helper'

describe User do
  let(:user) { create(:user) }
  
  it { should have_many :products }
  it { should have_many :orders}
  
  it { should have_field(:paypal_id).of_type(String) }
end
