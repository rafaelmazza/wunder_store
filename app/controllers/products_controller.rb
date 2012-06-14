class ProductsController < ApplicationController
  before_filter :authenticate_user!, except: [:show]
  load_and_authorize_resource
  
  def index
    @products = Product.all
  end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(params[:product])
    @product.save
    redirect_to products_path
    # render :text =>  params
  end
  
  def edit
    @product = Product.find(params[:id])
  end
  
  def update
    @product = Product.find(params[:id])
    @product.update_attributes(params[:product])
    redirect_to products_path
    # render :text => params[:product]
  end
  
  def show
    @product = Product.find(params[:id])
  end
  
  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path
  end
end
