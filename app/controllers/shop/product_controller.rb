#encoding: UTF-8
class Shop::ProductController < ApplicationController
  def index

  end

  def show
    @shop_product = ShopProduct.find(params[:id])
    unless @product = @shop_product.product
      flash[:error] = "产品不存在！"
      redirect_to :back
    end
  end

end
