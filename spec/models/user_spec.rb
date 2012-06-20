require 'spec_helper'

describe User do
  let(:user) { create(:user) }
  
  it { should have_many :products }
  it { should have_many :orders}
end
