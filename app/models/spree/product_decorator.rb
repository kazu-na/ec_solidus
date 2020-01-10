Spree::Product.class_eval do
  scope :add_price_image, -> { includes(master: [:default_price, :images]) }
  scope :new_products,    -> { order(available_on: :desc) }
  scope :old_products,    -> { order(available_on: :asc) }
  scope :position_order,  -> { order("spree_assets.position" => :asc) }
  scope :sort_by_order,   -> (sort) do
    case sort
    when "NEW_PRODUCTS"
      reorder(nil).new_products.position_order
    when "OLD_PRODUCTS"
      reorder(nil).old_products.position_order
    when "LOW_PRICE"
      unscope(:order).ascend_by_master_price.position_order
    when "HIGH_PRICE"
      unscope(:order).descend_by_master_price.position_order
    else
      reorder(nil).new_products.position_order
    end
  end
  scope :search_option,   -> (option_value) do
    joins(variants: :option_values).
    where(spree_option_values: { name: option_value })
  end
  scope :search_word,     -> (search_word) do
    search_word = sanitize_sql_like(search_word)
    where('name LIKE ? OR description LIKE ?', "%#{ search_word }%", "%#{ search_word }%") if search_word.present?
  end

  def related_products
    Spree::Product.in_taxons(taxons).
      add_price_image.
      where.not(id: id).
      distinct
  end
end
