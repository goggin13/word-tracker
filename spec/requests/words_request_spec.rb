require 'spec_helper'

describe "Words", type: "request" do
  describe "GET /words" do
    before do
      @user = FactoryGirl.create(:user)
    end

    it "renders an HTML page with all of the words" do
      word = FactoryGirl.create(:word, text: "word1", user: @user)
      FactoryGirl.create(:definition, text: "word1 means word1", word: word)

      integration_login(@user)
      visit words_path(format: "html")

      page.should have_content "word1"
      page.should have_content "word1 means word1"
      page.should have_link "word1", href: word_path(word)
    end

    it "renders an HTML page with all of the words even if they don't have definitions" do
      word = FactoryGirl.create(:word, text: "word1", user: @user)

      integration_login(@user)
      visit words_path(format: "html")

      page.should have_content "word1"
    end

    it "provides a link to delete the word" do
      integration_login @user
      word = FactoryGirl.create(:word, user: @user)

      visit words_path(format: "html")

      page.should have_button("delete")
      expect do
        click_button "delete"
      end.to change(Word, :count).by(-1)

      Word.find_by_id(word.id).should be_nil
    end
  end

  describe "new words" do
    it "creates a new word and definition from the wordnik api" do
      integration_login FactoryGirl.create(:user)
      visit new_word_path

      VCR.use_cassette "hysteria_api_response" do
        fill_in "Word", with: "hysteria"

      expect do
        expect do
            click_button "Create Word"
          end.to change(Word, :count).by(1)
        end.to change(Definition, :count).by(2)
      end

      page.should have_content "hysteria was successfully created."

      word = Word.find_by_text("hysteria")
      word.should_not be_nil
      word.definitions[0].text.should == "Behavior exhibiting excessive or uncontrollable emotion, such as fear or panic."

      word.definitions[1].text.should == "A mental disorder characterized by emotional excitability and sometimes by amnesia or a physical deficit, such as paralysis, or a sensory deficit, without an organic cause."
    end

    it "re-renders the form with an error if wordnik does not have the word" do
      integration_login FactoryGirl.create(:user)
      visit new_word_path

      VCR.use_cassette "not_found_api_response" do
        fill_in "Word", with: "this-word-wont-be-found"

        expect do
          click_button "Create Word"
        end.to change(Word, :count).by(0)
      end

      page.should have_content "No definition found for 'this-word-wont-be-found'"
    end
  end

  describe "show" do
    it "lists the word and its definitions" do
      word = FactoryGirl.create(:word, text: "my-word")
      definition_1 = FactoryGirl.create(:definition, word: word, text: "my-definition-1")
      definition_2 = FactoryGirl.create(:definition, word: word, text: "my-definition-2")

      visit word_path(word)

      page.should have_content "my-word"
      page.should have_content "my-definition-1"
      page.should have_content "my-definition-2"

      page.should have_link "edit", href: edit_word_definition_path(word, definition_1)
      page.should have_link "edit", href: edit_word_definition_path(word, definition_2)
    end

    it "allows you to delete a definition" do
      integration_login FactoryGirl.create(:user)

      definition = FactoryGirl.create(:definition)
      visit word_path(definition.word)

      click_button "delete"

      page.should have_content "Definition was successfully destroyed."
      Definition.find_by_id(definition.id).should be_nil
    end
  end
end
