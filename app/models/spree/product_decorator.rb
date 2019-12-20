Spree::Product.class_eval do
  scope :add_price_image, -> { includes(master: [:default_price, :images]) }
  scope :latest_order, -> (count) { order(available_on: :desc).limit(count) }
  scope :search_option, -> (option_value) {
    joins(variants: :option_values).
    where(spree_option_values: { name: option_value })
  }

  def related_products
    Spree::Product.in_taxons(taxons).
      add_price_image.
      where.not(id: id).
      distinct
  end
end
