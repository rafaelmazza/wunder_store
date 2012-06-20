require 'spec_helper'

describe Order do
  it { should belong_to :user }
  it { should have_field(:quantity).of_type(Integer) }
  it { should embed_one :address }
end