require 'rails_helper'

RSpec.describe "CategoriesRequests", type: :request do
  describe "GET #show" do
    let(:taxonomy)     { create(:taxonomy, name: 'Categories') }
    let(:taxon)        { create(:taxon,    name: 'Bags', taxonomy: taxonomy) }
    let!(:product)     { create(:product,  name: 'TOTE', taxons: [taxon]) }
    let(:product_etc)  { create(:product,  name: 'STATUE') }

    before do
      get potepan_category_path(taxon.id)
    end

    it "正常なレスポンス" do
      expect(response).to have_http_status(200)
    end

    it 'taxonomyが値を取得できているか' do
      expect(response.body).to include 'Categories'
    end

    it 'taxonが値を取得できているか' do
      expect(response.body).to include 'Bags'
    end

    it 'productが値を取得できているか' do
      expect(response.body).to include 'TOTE'
    end

    it '関連していないproductが含まれていないか' do
      expect(response.body).not_to include 'STATUE'
    end
  end
end
