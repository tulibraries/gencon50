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
end
