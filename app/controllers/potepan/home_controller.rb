class Potepan::HomeController < ApplicationController
  MAX_LATEST_ITEM_COUNT = 12
  def index
    @new_products = Spree::Product.add_price_image.latest_order(MAX_LATEST_ITEM_COUNT)
  end
end
