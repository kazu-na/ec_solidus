require 'rails_helper'

RSpec.describe "HomeRequests", type: :request do
  describe "GET #top" do
    before do
      get potepan_path
    end

    it "正常なレスポンス" do
      expect(response).to have_http_status(200)
    end
  end
end
