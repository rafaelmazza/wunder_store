require 'spec_helper'

describe Payment do
  it { should be_a(Mongoid::Document) }
  it { should be_timestamped_document }
  it { should belong_to(:order) }
  it { should have_field(:amount).of_type(Integer) }
  it { should have_many(:transfers) }
end