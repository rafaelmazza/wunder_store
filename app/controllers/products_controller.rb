class ProductsController < ApplicationController
  def index
    @products = Product.all
  end
  
  def new
    @product = Product.new
    @product.variants.build # master variant
    option_type = @product.option_types.build
    2.times { option_type.option_values.build }
  end
  
  def create
    @product = Product.new(params[:product])
    
    # TODO: move to model
    option_type = @product.option_types.first
    @product.master.option_values << option_type.option_values
    
    @product.save
    redirect_to products_path
  end
  
  def edit
    @product = Product.find(params[:id])
  end
  
  def update
    @product = Product.find(params[:id])
    @product.update_attributes(params[:product])
    redirect_to products_path
  end
  
  def show
    @product = Product.find(params[:id])
  end
end
