class ProductsController < ApplicationController
  def index
    @products = Product.all
  end
  
  def new
    @product = Product.new
    variant = @product.variants.build
    # 1.times {@product.images.build}
    1.times {@product.master.images.build}
    
    # variant.images.build
    # 2.times { @product.master.images.build }
    # @product.variants.build # master variant
    # option_type = @product.option_types.build
    # 2.times { option_type.option_values.build }
  end
  
  def create
    @product = Product.new(params[:product])
    
    # TODO: move to model
    # option_type = @product.option_types.first
    # # @product.master.option_values << option_type.option_values    
    @product.save
    # option_type.option_values.each do |ov|
    #   variant = @product.variants.create({ :option_value_ids => [ov.id], :price => @product.master.price }, :without_protection => true)
    #   p variant.inspect
    # end
    
    redirect_to products_path
    # render :text =>  params[:product]
  end
  
  def edit
    @product = Product.find(params[:id])
    # 2.times {@product.master.images.build}
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
