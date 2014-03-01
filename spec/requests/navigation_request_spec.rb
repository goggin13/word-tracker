require "spec_helper"

describe "navigation" do
  describe "sidebar" do
    it "contains links to the most recently posted 10 words" do
      definitions = (0..9).map { FactoryGirl.create(:definition) }
      visit "/"

      sidebar = page.find(".sidebar-nav")
      definitions.each do |definition|
        sidebar.should have_link definition.word, definition_path(definition)
      end
    end

    xit "doesn't contain duplicates" do
      FactoryGirl.create(:definition, word: "hello")
      FactoryGirl.create(:definition, word: "hello")
      visit "/"

      sidebar = page.find(".sidebar-nav")
      sidebar.should have_link "hello", count: 1
    end
  end
end
