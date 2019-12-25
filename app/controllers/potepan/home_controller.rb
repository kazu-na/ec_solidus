class Potepan::HomeController < ApplicationController
  MAX_NEW_ITEM_COUNT = 12
  POPULAR_TAXONS     = %w(Clothing Bags Mugs).freeze

  def index
    @popular_taxons = Spree::Taxon.where(name: POPULAR_TAXONS)
    @new_products   = Spree::Product.add_price_image.new_products.limit(MAX_NEW_ITEM_COUNT)
  end
end
