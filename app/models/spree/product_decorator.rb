Spree::Product.class_eval do
  scope :add_price_image, -> { includes(master: [:default_price, :images]) }
  scope :new_products,    -> { order(available_on: :desc) }
  scope :old_products,    -> { order(available_on: :asc) }
  scope :sort_by_order,   -> (sort) do
    case sort
    when "NEW_PRODUCTS"
      reorder(nil).new_products
    when "OLD_PRODUCTS"
      reorder(nil).old_products
    when "LOW_PRICE"
      unscope(:order).ascend_by_master_price
    when "HIGH_PRICE"
      unscope(:order).descend_by_master_price
    end
  end
  scope :search_option,   -> (option_value) do
    joins(variants: :option_values).
    where(spree_option_values: { name: option_value })
  end

  def related_products
    Spree::Product.in_taxons(taxons).
      add_price_image.
      where.not(id: id).
      distinct
  end
end
