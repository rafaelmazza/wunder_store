require 'spec_helper'

describe 'User orders requests' do
  # before do
  #   as(:user)
  # end
  
  let!(:current_user) { as(:user) }
  let!(:another_user) { create(:user) }
  let!(:another_user_order) { create(:order, user: another_user) }
  let!(:current_user_order ) { create(:order, user: current_user) }
  
  context 'list orders' do
    it 'lists only current user orders' do
      visit orders_path
      page.should have_content(current_user_order.id)
      page.should_not have_content(another_user_order.id)
    end
  end
  
  context 'view order details' do
    it 'display order details' do
      visit orders_path
      click_on current_user_order.id.to_s
      current_path.should == order_path(current_user_order)
      find('.id').should have_content(current_user_order.id)
      find('.total').should have_content(current_user_order.total)
      find('.first-name').should have_content(current_user_order.first_name)
      find('.last-name').should have_content(current_user_order.last_name)
    end
  end
end