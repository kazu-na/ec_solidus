require 'rails_helper'

RSpec.describe "ProductsRequests", type: :request do
  describe "GET #show" do
    let(:taxon)             { create(:taxon) }
    let!(:product)          { create(:product, name: 'TOTE', taxons: [taxon]) }
    let!(:product_etc)      { create(:product, name: 'STATUE') }
    let(:related_products)  { create_list(:product, 20, taxons: [taxon]) }

    before do
      get potepan_product_path(product.id)
      stub_const("Potepan::ProductsController::MAX_RELATED_ITEM_COUNT", 12)
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
      expect(product.related_products.limit(Potepan::ProductsController::MAX_RELATED_ITEM_COUNT).count).to eq 12
    end
  end

  describe "GET #search" do
    let!(:ruby_product_1)        { create(:product, name: 'RUBY TOTE', description: 'TOTE') }
    let!(:ruby_product_2)        { create(:product, name: 'MUG',       description: 'RUBY MUG') }
    let!(:metacharacter_product) { create(:product, name: 'STATUE',    description: 'FOOBAR100%') }

    context "検索ワードを入力したとき" do
      before do
        get search_potepan_products_path(search: 'RUBY')
      end

      it "正常なレスポンス" do
        expect(response).to have_http_status(200)
      end

      it "検索ワードに該当している商品のみが表示されていること" do
        expect(response.body).to     include 'RUBY TOTE'
        expect(response.body).to     include 'MUG'
        expect(response.body).not_to include 'STATUE'
      end
    end

    context "検索ワードが空白のとき" do
      before do
        get search_potepan_products_path(search: '')
      end

      it "正常なレスポンス" do
        expect(response).to have_http_status(200)
      end

      it "空白だと全ての商品が表示されていること" do
        expect(response.body).to include 'RUBY TOTE'
        expect(response.body).to include 'MUG'
        expect(response.body).to include 'STATUE'
      end
    end

    context "検索ワードにメタキャラクタを使用したとき" do
      before do
        get search_potepan_products_path(search: '100%')
      end

      it "正常なレスポンス" do
        expect(response).to have_http_status(200)
      end

      it "メタキャラクタを含んだワードでも正常に検索できていること" do
        expect(response.body).not_to include 'RUBY TOTE'
        expect(response.body).not_to include 'MUG'
        expect(response.body).to     include 'STATUE'
      end
    end
  end
end
