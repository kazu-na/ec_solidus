require 'rails_helper'

RSpec.describe "HomeRequests", type: :request do
  describe "GET #index" do
    let(:new_products) { create_list(:product, 20) }

    before do
      get potepan_path
      stub_const("Potepan::HomeController::MAX_NEW_ITEM_COUNT", 12)
    end

    it "正常なレスポンス" do
      expect(response).to have_http_status(200)
    end

    it "新着数が13以上であっても上限設定数の12になっているか" do
      expect(new_products.count).to eq 20
      expect(Spree::Product.latest_order(Potepan::HomeController::MAX_NEW_ITEM_COUNT).count).to eq 12
    end
  end
end
