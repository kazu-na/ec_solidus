require 'rails_helper'

RSpec.describe "HomeSystems", type: :system do
  describe "home pages" do
    before do
      visit potepan_path
    end

    it "タイトルが表示されていること" do
      expect(page).to have_title 'BIGBAG Store'
    end

    it "ヘッダーにあるトップへのリンク数を確認" do
      within '.header' do
        expect(page.all("a[href='#{potepan_path}']").size).to eq(2)
      end
    end
  end
end
