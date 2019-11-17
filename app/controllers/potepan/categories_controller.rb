class Potepan::CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:id])
    @products = Spree::Product.in_taxon(@taxon).includes(master: [:images, :default_price])
    @taxonomies = Spree::Taxonomy.includes(:taxons)
  end
end
