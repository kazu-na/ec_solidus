module Spree::ProductDecorator
  def self.prepended(base)
    base.scope :add_price_image, -> { includes(master: [:default_price, :images]) }
    base.scope :latest_order, -> (count) { order(available_on: :desc).limit(count) }
  end

  def related_products
    Spree::Product.in_taxons(taxons).
      add_price_image.
      where.not(id: id).
      distinct
  end
  Spree::Product.prepend self
end
