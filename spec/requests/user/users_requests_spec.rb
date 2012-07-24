require 'spec_helper'

describe 'User requests' do
  let!(:current_user) { create_logged_in_user }
  
  context 'edit user' do
    let(:paypal_id) { 'john_1336691024_per@cafeazul.com.br' }
    
    it 'add paypal ID' do
      visit edit_user_registration_path
      fill_in 'Paypal', with: paypal_id
      fill_in 'Current password', with: current_user.password
      click_on 'Update'
      visit edit_user_registration_path
      # current_path.should == edit_user_registration_path
      page.should have_field 'Paypal', with: paypal_id
    end
  end
end