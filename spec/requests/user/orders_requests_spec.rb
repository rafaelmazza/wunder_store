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
end