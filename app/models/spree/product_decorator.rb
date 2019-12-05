module Spree::ProductDecorator
  def related_products
    Spree::Product.in_taxons(taxons).
      includes(master: [:default_price, :images]).
      where.not(id: id).
      distinct
  end
  Spree::Product.prepend self
end
