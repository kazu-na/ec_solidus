class Potepan::CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:id])
    @products = Spree::Product.in_taxon(@taxon).add_price_image
    @taxonomies = Spree::Taxonomy.includes(:taxons)
  end
end
