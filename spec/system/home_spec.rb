require 'rails_helper'

RSpec.describe "HomeSystems", type: :system do
  describe "home pages" do
    let(:taxon)        { create(:taxon) }
    let!(:new_product) do
      create(:product, name: 'TOTE',
                       price: 500.50,
                       available_on: 1.day.ago,
                       taxons: [taxon])
    end
    let!(:old_product) { create(:product, available_on: 2.day.ago, taxons: [taxon]) }

    before do
      visit potepan_path
    end

    it "タイトルが表示されていること" do
      expect(page).to have_title 'BIGBAG Store'
    end

    it "ヘッダーにあるトップへのリンク数を確認" do
      within '.header' do
        expect(page.all("a[href='#{potepan_path}']").size).to eq(2)
      end
    end

    it "商品と価格が表示されること" do
      within '.featuredProducts' do
        expect(page).to have_content 'TOTE'
        expect(page).to have_content '500.50'
      end
    end

    it "新着順に表示されること" do
      expect(Spree::Product.latest_order(2)).to match [new_product, old_product]
    end

    it "新着商品から商品詳細ページへ移動" do
      expect(page).to have_link 'TOTE'
      click_on 'TOTE'
      expect(current_path).to eq potepan_product_path(new_product.id)
    end
  end
end
