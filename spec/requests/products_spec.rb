require 'rails_helper'

RSpec.describe "ProductsRequests", type: :request do
  describe "GET #show" do
    let(:product) { create(:product) }

    before do
      get potepan_product_path(product.id)
    end

    it "正常なレスポンス" do
      expect(response).to have_http_status(200)
    end

    describe 'productが値を取得できているか' do
      let(:product) { create(:product, name: 'foobar') }

      it '値がページ中に含まれていること' do
        expect(response.body).to include 'foobar'
      end
    end
  end
end
