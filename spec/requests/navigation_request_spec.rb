require "spec_helper"

describe "navigation" do
  before do
    @user = FactoryGirl.create(:user)
  end

  it "has a link to the home page" do
    integration_login @user
    visit "/"
    page.should have_link "MyWords", href: "/"
  end

  describe "sidebar" do
    it "contains links to the most recently posted 10 words" do
      integration_login @user
      words = (0..9).map { FactoryGirl.create(:word) }
      visit "/"

      sidebar = page.find(".sidebar-nav")
      words.each do |word|
        sidebar.should have_link word.text, word_path(word)
      end
    end
  end

  describe "logged in" do
    before do
      @user = FactoryGirl.create(
        :user,
        :email => "test@example.com",
        :password => "test-password"
      )

      integration_login(@user)
    end

    it "displays a link for the user's account" do
      visit "/"
      page.should have_link("test@example.com", href: edit_user_registration_path(@user))
    end

    it "has a link to log the user out" do
      FactoryGirl.create(:user, :default)
      visit "/"
      page.should have_link("Log out", href: destroy_user_session_path)

      click_link "Log out"

      page.should have_content "Signed out successfully."
    end
  end
end
