require 'spec_helper'

describe ProductsController do
  context 'as user' do
    before do
      @abilities = Ability.new(current_user)
      Ability.stub(:new).and_return(@abilities)
    end
    
    let!(:current_user) { as(:user) }
    let!(:product) { create(:product, user: current_user) }
    let(:another_user_product) { create(:product, user: create(:user)) }
    
    context 'GET #edit' do
      it 'does not edit another user product' do
        @abilities.stub!(:can?).with(:edit, another_user_product).and_return(true)
        expect {
          get :edit, id: another_user_product, product: attributes_for(:product)
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end
    
    context 'PUT #update' do
      it 'updates product owned by current user' do
        put :update, id: product, product: attributes_for(:product)
        assigns(:product).user.should == current_user
      end

      it 'does not update another user product' do
        @abilities.stub!(:can?).with(:update, another_user_product).and_return(true)
        expect {
          put :update, id: another_user_product
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end
    
    context 'DELETE #destroy' do
      it 'only delete own products' do
        expect {
          delete :destroy, id: product
        }.to change(current_user.products, :count).by(-1)
      end

      it 'does not delete another user product' do
        @abilities.stub!(:can?).with(:destroy, another_user_product).and_return(true)
        expect {
          delete :destroy, id: another_user_product
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end

    context 'POST #create' do    
      it 'creates product owned by current user' do
        post :create, :product => attributes_for(:product)
        assigns(:product).user.should == current_user
      end
    end
  end
end