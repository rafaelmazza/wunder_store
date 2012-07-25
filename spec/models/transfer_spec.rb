require 'spec_helper'

describe Transfer do
  it { should be_a(Mongoid::Document) }
  it { should be_timestamped_document }
  it { should belong_to(:payment) }
end