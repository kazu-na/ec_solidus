require 'rails_helper'

RSpec.describe "ProductsRequests", type: :request do
  describe "GET #show" do
    let(:taxon)             { create(:taxon) }
    let!(:product)          { create(:product, name: 'TOTE', taxons: [taxon]) }
    let(:product_etc)       { create(:product, name: 'STATUE') }
    let(:related_products)  { create_list(:product, 20, taxons: [taxon]) }

    before do
      get potepan_product_path(product.id)
    end

    it "正常なレスポンス" do
      expect(response).to have_http_status(200)
    end

    it 'productが値を取得できているか' do
      expect(response.body).to include 'TOTE'
    end

    it '関連していないproductが含まれていないか' do
      expect(response.body).not_to include 'STATUE'
    end

    it "関連数が13以上であっても上限設定数の12になっているか" do
      expect(related_products.count).to eq 20
      expect(product.related_products.count).to eq 12
    end
  end
end
