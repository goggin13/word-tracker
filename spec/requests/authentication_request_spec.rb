require 'spec_helper'

describe "Authetnication", type: "request" do
  it "displays a welcome message after logging in" do
    user = FactoryGirl.create(:user)
    visit new_user_session_path

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end

  describe "navigation links" do
    it "displays logout 'username' and an account link when logged in" do
      user = FactoryGirl.create(:user, email: "person@hotmail.com")
      visit new_user_session_path

      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"

      page.should have_content "Signed in successfully."
      page.should have_link "person@hotmail.com", href: edit_user_registration_path(user)
      page.should have_link "Log out", href: destroy_user_session_path
    end

    it "displays a Login link when not logged in" do
      FactoryGirl.create(:user, :default)
      visit "/"
      page.should have_link "Login", href: new_user_session_path
    end
  end
end
