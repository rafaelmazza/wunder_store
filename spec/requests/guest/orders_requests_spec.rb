require 'spec_helper'

describe 'Guest orders requests' do
  let(:user) { create(:user) }
  let(:product) { create(:product, user: user) }
  # let(:order) { create(:order) }
  
  # before do
  #   # product.stub_chain(:user, :orders, :build).and_return(order)
  # end

  it 'create an order' do
    visit product_path(product)
    # p page.body
    fill_in :quantity, with: 1
    click_on 'Buy'
    
    # current_path.should == edit_order_path(order)
    order = Order.last
    current_path.should == edit_order_path(order)
    
    fill_in :email, with: 'rafael@cafeazul.com.br'
    fill_in :first_name, with: 'Rafael'
    fill_in :last_name, with: 'Mazza'
    fill_in :address, with: 'Av. Moema 170, conjunto 65'
    fill_in :city, with: 'Sao Paulo'
    fill_in :state, with: 'Sao Paulo'
    fill_in :zipcode, with: '04077-020'
    fill_in :phone, with: '55 11 5052-7001'
    # select 'Brazil', from: 'country'
  end
end