require 'spec_helper'

describe "cms_members" do
  subject(:site) { cms_site }
  subject(:item) { Cms::Member.last }
  subject(:index_path) { cms_members_path site.id }
  subject(:new_path) { new_cms_member_path site.id }
  subject(:show_path) { cms_member_path site.id, item }
  subject(:edit_path) { edit_cms_member_path site.id, item }
  subject(:delete_path) { delete_cms_member_path site.id, item }

  context "with auth" do
    before { login_cms_user }

    it "#index" do
      visit index_path
      expect(current_path).not_to eq sns_login_path
    end

    it "#new" do
      visit new_path
      within "form#item-form" do
        fill_in "item[name]", with: "sample"
        fill_in "item[email]", with: "member_sample@example.jp"
        fill_in "item[in_password]", with: "abc123"
        click_button "保存"
      end
      expect(status_code).to eq 200
      expect(current_path).not_to eq new_path
      expect(page).to have_no_css("form#item-form")
    end

    it "#show" do
      visit show_path
      expect(status_code).to eq 200
      expect(current_path).not_to eq sns_login_path
    end

    it "#edit" do
      visit edit_path
      within "form#item-form" do
        fill_in "item[name]", with: "modify"
        click_button "保存"
      end
      expect(current_path).not_to eq sns_login_path
      expect(page).to have_no_css("form#item-form")
    end

    it "#delete" do
      visit delete_path
      within "form" do
        click_button "削除"
      end
      expect(current_path).to eq index_path
    end
  end
end