class Potepan::CategoriesController < ApplicationController
  helper_method :count_products_option

  def show
    @taxon         = Spree::Taxon.find(params[:id])
    @taxonomies    = Spree::Taxonomy.includes(:taxons)
    @colors        = Spree::OptionType.find_by(presentation: "Color").option_values
    @sizes         = Spree::OptionType.find_by(presentation: "Size").option_values
    @base_products = Spree::Product.in_taxon(@taxon)
    @products      = products_search
  end

  private

  def count_products_option(option_value)
    @base_products.search_option(option_value).count
  end

  def products_search
    master_products = @base_products.add_price_image
    params[:option].blank? ? master_products : master_products.search_option(params[:option])
  end
end
