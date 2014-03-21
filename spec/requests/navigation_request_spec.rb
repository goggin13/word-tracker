require "spec_helper"

describe "navigation" do
  it "has a link to the home page" do
    visit "/"
    page.should have_link "MyWords", href: "/"
  end

  describe "sidebar" do
    it "contains links to the most recently posted 10 words" do
      words = (0..9).map { FactoryGirl.create(:word) }
      visit "/"

      sidebar = page.find(".sidebar-nav")
      words.each do |word|
        sidebar.should have_link word.text, word_path(word)
      end
    end
  end
end
