class ProductsController < ApplicationController
  
  before_action :set_product, only: [:show, :update, :destroy]
  
  def index
    @product = Product.all
    json_response(@product)
  end

  def create
    @product = Product.create!(product_params)
    json_response(@product, :created)
  end

  def show
    json_response(@product)
  end

  def update
    @product.update(product_params)
    head :no_content
  end

  def destroy
    @product.destroy
    head :no_content
  end
  
  private

  def product_params
    params.require(:product).permit(:name, :price)
  end
  
  def set_product
    @product = Product.find(params[:id])
  end
  
end
