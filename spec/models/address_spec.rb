require 'spec_helper'

describe Address do
  it { should be_embedded_in :order }
  it { should have_field(:address).of_type(String) }
  it { should have_field(:city).of_type(String) }
  it { should have_field(:state).of_type(String) }
  it { should have_field(:zipcode).of_type(String) }
end