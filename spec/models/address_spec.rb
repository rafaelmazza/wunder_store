require 'spec_helper'

describe Address do
  it { should be_embedded_in :order }
end