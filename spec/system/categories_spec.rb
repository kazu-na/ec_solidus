require 'rails_helper'

RSpec.describe "CategoriesSystems", type: :system do
  describe "categories pages" do
    let(:taxonomy)      { create(:taxonomy,     name: 'Categories') }
    let(:taxon_1)       { create(:taxon,        name: 'Bags',  taxonomy: taxonomy) }
    let(:taxon_2)       { create(:taxon,        name: 'Mugs',  taxonomy: taxonomy) }
    let!(:colors)       { create(:option_type,  presentation: 'Color') }
    let!(:sizes)        { create(:option_type,  presentation: 'Size') }
    let!(:option_red)   { create(:option_value, name: 'Red',   option_type: colors) }
    let!(:option_small) { create(:option_value, name: 'Small', option_type: sizes) }
    let!(:product_1) do
      create(:product, name: 'TOTE',
                       price: 500.50,
                       taxons: [taxon_1],
                       option_types: [colors])
    end
    let!(:product_2) do
      create(:product, name: 'STEIN',
                       price: 300.30,
                       taxons: [taxon_2],
                       option_types: [sizes])
    end
    let!(:product_3)       { create(:product, name: 'Pouch', taxons: [taxon_1]) }
    let!(:product_4)       { create(:product, name: 'Cup',   taxons: [taxon_2]) }
    let!(:product_1_value) { create(:variant, product: product_1, option_values: [option_red]) }
    let!(:product_2_value) { create(:variant, product: product_2, option_values: [option_small]) }

    before do
      visit potepan_category_path(taxon_1.id)
    end

    it "サイドバーにはカテゴリー、カラー、サイズのタブが表示されていること" do
      within '.sideBar' do
        expect(page).to have_content 'Categories'
        expect(page).to have_content 'Red'
        expect(page).to have_content 'Small'
      end
    end

    it "カテゴリー名と括弧内に商品数が表示されること" do
      expect(page).to have_content 'Bags (2)'
    end

    it "カテゴリーページから商品詳細ページへ移動" do
      expect(page).to have_link 'TOTE'
      click_on 'TOTE'
      expect(current_path).to eq potepan_product_path(product_1.id)
    end

    it "カテゴリー名をクリックしたページ先にはカテゴリーに関連する商品名と金額が表示されること" do
      expect(page).to have_link 'Mugs (2)'
      click_on 'Mugs (2)'
      expect(current_path).to eq potepan_category_path(taxon_2.id)
      within '.productBox', match: :first do
        expect(page).to     have_content 'STEIN'
        expect(page).to     have_content '300.30'
        expect(page).not_to have_content 'TOTE'
      end
    end

    it "カラーのある商品のみが表示されていること" do
      expect(page).to have_link 'Red'
      click_on 'Red'
      within '.productBox' do
        expect(page).to     have_content 'TOTE'
        expect(page).not_to have_content 'Pouch'
      end
    end

    it "サイズのある商品のみが表示されていること" do
      visit potepan_category_path(taxon_2.id)
      expect(page).to have_link 'Small'
      click_on 'Small'
      within '.productBox' do
        expect(page).to     have_content 'STEIN'
        expect(page).not_to have_content 'Cup'
      end
    end
  end
end
