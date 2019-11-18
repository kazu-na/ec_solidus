require 'rails_helper'

RSpec.describe "CategoriesSystems", type: :system do
  describe "categories pages" do
    let (:taxonomy)  { create(:taxonomy, name: 'Categories') }
    let (:taxon_1)   { create(:taxon,    name: 'Bags',  taxonomy: taxonomy) }
    let (:taxon_2)   { create(:taxon,    name: 'Mugs',  taxonomy: taxonomy) }
    let!(:product_1) { create(:product,  name: 'TOTE',  price: 500.50, taxons: [taxon_1]) }
    let!(:product_2) { create(:product,  name: 'STEIN', price: 300.30, taxons: [taxon_2]) }

    before do
      visit potepan_category_path(taxon_1.id)
    end

    it "カテゴリー名と括弧内に商品数が表示されること" do
      expect(page).to have_content 'Bags (1)'
    end

    it "カテゴリーページから商品詳細ページへ移動" do
      expect(page).to have_link 'TOTE'
      click_on 'TOTE'
      expect(current_path).to eq potepan_product_path(product_1.id)
    end

    it "カテゴリー名をクリックしたページ先にはカテゴリーに関連する商品名と金額が表示されること" do
      expect(page).to have_link 'Mugs'
      click_on 'Mugs'
      expect(current_path).to eq potepan_category_path(taxon_2.id)
      within '.productBox' do
        expect(page).to have_content 'STEIN'
        expect(page).to have_content '300.30'
        expect(page).not_to have_content 'TOTE'
      end
    end
  end
end
