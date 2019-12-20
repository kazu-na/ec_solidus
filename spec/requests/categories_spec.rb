require 'rails_helper'

RSpec.describe "CategoriesRequests", type: :request do
  describe "GET #show" do
    let(:taxonomy)      { create(:taxonomy,    name: 'Categories') }
    let(:taxon)         { create(:taxon,       name: 'Bags', taxonomy: taxonomy) }
    let!(:product)      { create(:product,     name: 'TOTE', taxons: [taxon]) }
    let!(:product_etc)  { create(:product,     name: 'STATUE') }
    let!(:colors)       { create(:option_type, presentation: 'Color') }
    let!(:sizes)        { create(:option_type, presentation: 'Size') }
    let!(:option_red)   { create(:option_value, name: 'Red',   option_type: colors) }
    let!(:option_small) { create(:option_value, name: 'Small', option_type: sizes) }
    let!(:option_etc)   { create(:option_value, name: 'Big') }

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

    it 'option_valueが値を取得できているか' do
      expect(response.body).to include 'Red'
      expect(response.body).to include 'Small'
    end

    it '関連していないoption_valueが含まれていないか' do
      expect(response.body).not_to include 'Big'
    end
  end
end
