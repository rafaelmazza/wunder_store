class ProductsController < ApplicationController
  before_filter :authenticate_user!, except: [:show]
  load_and_authorize_resource
  
  def index
    @products = current_user.products
  end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = current_user.products.new(params[:product])
    @product.save
    redirect_to products_path
  end
  
  def edit
    @product = current_user.products.find(params[:id])
  end
  
  def update
    @product = current_user.products.find(params[:id])
    @product.update_attributes(params[:product])
    redirect_to products_path
  end
  
  def show
    @product = Product.find(params[:id])
        
    @order = @product.user.orders.build
  end
  
  def destroy
    @product = current_user.products.find(params[:id])
    @product.destroy
    redirect_to products_path
  end
end
