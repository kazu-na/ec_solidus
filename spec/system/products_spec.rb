require 'rails_helper'

RSpec.describe "ProductsSystems", type: :system do
  describe "products pages" do
    let(:taxon_1) { create(:taxon, name: 'Bags') }
    let(:taxon_2) { create(:taxon, name: 'Mugs') }
    let!(:product_1) do
      create(:product, name: 'TOTE',
                       price: 500.50,
                       description: 'foobar',
                       taxons: [taxon_1])
    end
    let!(:product_2) do
      create(:product, name: 'BAG',
                       price: 300.30,
                       taxons: [taxon_1])
    end
    let!(:product_3) { create(:product,     name: 'STEIN', taxons: [taxon_2]) }
    let!(:colors)    { create(:option_type, presentation: 'Color') }
    let!(:sizes)     { create(:option_type, presentation: 'Size') }

    before do
      visit potepan_product_path(product_1.id)
    end

    it "商品詳細が表示されること" do
      within '.media-body' do
        expect(page).to have_content 'TOTE'
        expect(page).to have_content '500.50'
        expect(page).to have_content 'foobar'
      end
    end

    it "商品詳細ページから関連したカテゴリーの一覧ページへ移動" do
      expect(page).to have_link '一覧ページへ戻る'
      click_on '一覧ページへ戻る'
      expect(current_path).to eq potepan_category_path(taxon_1.id)
    end

    it "関連した商品が表示され、閲覧中の商品と関連していない商品は表示されないこと" do
      within '.productBox' do
        expect(page).to     have_content 'BAG'
        expect(page).to     have_content '300.30'
        expect(page).not_to have_content 'TOTE'
        expect(page).not_to have_content 'STEIN'
      end
    end

    it "検索ページから商品詳細ページへ移動" do
      visit search_potepan_products_path(search: 'TOTE')
      within '.productBox' do
        expect(page).to     have_content 'TOTE'
        expect(page).to     have_content '500.50'
        expect(page).not_to have_content 'BAG'
        expect(page).not_to have_content 'STEIN'
      end
      expect(page).to have_link 'TOTE'
      click_on 'TOTE'
      expect(current_path).to eq potepan_product_path(product_1.id)
    end
  end
end
