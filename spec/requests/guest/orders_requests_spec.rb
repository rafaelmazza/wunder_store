require 'spec_helper'

describe 'Guest orders requests' do
  let(:user) { create(:user) }
  let(:product) { create(:product, :price => 100, user: user) }

  it 'create an order' do
    visit product_path(product)
    fill_in 'quantity', with: 2
    click_on 'Buy'
    
    order = Order.first
    current_path.should == edit_order_path(order)
    find('.order-price').should have_content(200)
    
    fill_in 'Email', with: 'rafael@cafeazul.com.br'
    fill_in 'First name', with: 'Rafael'
    fill_in 'Last name', with: 'Mazza'
    fill_in 'Address', with: 'Av. Moema 170, conjunto 65'
    fill_in 'City', with: 'Sao Paulo'
    fill_in 'State', with: 'Sao Paulo'
    fill_in 'Zipcode', with: '04077-020'
    fill_in 'Phone', with: '55 11 5052-7001'
    select 'Brazil', from: 'Country'
  end
end