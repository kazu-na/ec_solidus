require 'rails_helper'

RSpec.describe "ProductsSystems", type: :system do
  describe "product pages" do
    let(:product) { create(:product) }

    before do
      visit potepan_product_path(product.id)
    end

    it "商品名が表示される" do
      expect(page).to have_content product.name
    end

    it "商品価格が表示される" do
      expect(page).to have_content product.display_price
    end

    it "商品説明が表示される" do
      expect(page).to have_content product.description
    end
  end
end
