# frozen_string_literal: true

require "rails_helper"

RSpec.feature "UploadWithAuthentications", type: :feature do
  before(:all) do
    @email = "admin@example.eom"
    @password = "password"
    @user = User.create!(email: @email, password: @password, password_confirmation: @password)
  end

  after(:all) do
    @user.destroy
  end

  context "Access upload page" do
    skip "GC-29 Workaround" do
    scenario "Create new item " do
      visit("/upload")
      expect(page).to_not have_xpath("//body[contains(., 'New Upload')]")
      expect(page).to have_xpath("//main[contains(., 'Log in')]")

      fill_in("Email", with: @email)
      fill_in("Password", with: @password)
      click_button("Log in")
      expect(page).to have_xpath("//body[contains(., 'New Upload')]")
    end
    end
  end
end
