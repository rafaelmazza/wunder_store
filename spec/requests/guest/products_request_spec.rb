require 'spec_helper'

describe 'Guest products requests' do
  # before do
  #   as_guest(:user)
  # end
  
  let(:product) { create(:product, :user => create(:user)) }
  
  it 'view a product' do
    visit product_path(product)
    page.should have_content(product.name)
  end
end