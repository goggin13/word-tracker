require "spec_helper"

describe "definitions" do
  describe "edit" do
    it "allows you to edit a definition" do
      integration_login FactoryGirl.create(:user)
      definition = FactoryGirl.create(:definition, text: "old definition")

      visit edit_word_definition_path(definition.word, definition)

      fill_in "Text", with: "new definition"
      click_button "Update Definition"

      page.should have_content "Definition was successfully updated."
      definition.reload.text.should == "new definition"
    end
  end
end