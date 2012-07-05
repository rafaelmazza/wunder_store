require 'spec_helper'

describe Payment do
  it { should be_a(Mongoid::Document) }
  it { should belong_to(:order) }
end