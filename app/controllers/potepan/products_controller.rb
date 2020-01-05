class Potepan::ProductsController < ApplicationController
  MAX_RELATED_ITEM_COUNT = 12
  def show
    @product = Spree::Product.find(params[:id])
    @related_products = @product.related_products.limit(MAX_RELATED_ITEM_COUNT)
  end

  def search
    @search_word = params[:search]
    @products = Spree::Product.add_price_image.search_word(@search_word)
  end
end
