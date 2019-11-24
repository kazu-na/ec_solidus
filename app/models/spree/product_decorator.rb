module Spree::ProductDecorator
  MAX_RELATED_ITEM_COUNT = 12
  def related_products
    Spree::Product.in_taxons(taxons).includes(master: [:default_price, :images]).where.not(id: id).distinct.limit(MAX_RELATED_ITEM_COUNT)
  end
  Spree::Product.prepend self
end
