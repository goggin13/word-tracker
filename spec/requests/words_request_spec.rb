require 'spec_helper'

describe "Words", type: "words" do
  describe "GET /words" do
    it "returns a JSON array with all the existing words" do
      FactoryGirl.create(
        :definition,
        text: "word1 means word1",
        word: FactoryGirl.create(:word, text: "word1")
      )
      FactoryGirl.create(
        :definition,
        text: "word2 means word2",
        word: FactoryGirl.create(:word, text: "word2")
      )

      get words_path(format: "json")

      response.status.should == 200
      JSON.parse(response.body).should == [
        { "word1" => ["word1 means word1"] },
        { "word2" => ["word2 means word2"] },
      ]
    end

    it "renders an HTML page with all of the words" do
      word = FactoryGirl.create(:word, text: "word1")
      FactoryGirl.create(:definition, text: "word1 means word1", word: word)

      visit words_path(format: "html")

      page.should have_content "word1"
      page.should have_content "word1 means word1"
      page.should have_link "word1", href: word_path(word)
    end

    it "renders an HTML page with all of the words even if they don't have definitions" do
      word = FactoryGirl.create(:word, text: "word1")

      visit words_path(format: "html")

      page.should have_content "word1"
    end
  end

  describe "POST /words.json" do
    it "returns existing definitions if they are available" do
      word = FactoryGirl.create(:word, text: "word1")
      FactoryGirl.create(:definition, text: "word1 means word1", word: word)
      FactoryGirl.create(:definition, text: "word1 also means word1", word: word)

      post words_path, word: "word1", format: :json

      response.status.should == 200
      JSON.parse(response.body).should == {
        "word1" => ["word1 means word1", "word1 also means word1"]
      }
    end

    it "looks up the defintion from wordnik" do
      VCR.use_cassette "hysteria_api_response" do
        post words_path, :word => "hysteria", format: :json
        response.status.should == 200
        result = JSON.parse(response.body)

        result.should == {
          "hysteria" => [
            "Behavior exhibiting excessive or uncontrollable emotion, such as fear or panic.",
            "A mental disorder characterized by emotional excitability and sometimes by amnesia or a physical deficit, such as paralysis, or a sensory deficit, without an organic cause."
          ]
        }
      end
    end

    it "returns 422 if the definition cannot be located" do
      VCR.use_cassette "not_found_api_response" do
        post words_path, :word => "this-word-wont-be-found", format: :json
        response.status.should == 422
        result = JSON.parse(response.body)
        result["errors"][0].should == "No definition found for 'this-word-wont-be-found'"
      end
    end
  end

  describe "new words" do
    it "creates a new word and definition from the wordnik api" do
      visit new_word_path

      VCR.use_cassette "hysteria_api_response" do
        fill_in "Word", with: "hysteria"

        expect do
        expect do
            click_button "Create Word"
          end.to change(Word, :count).by(1)
        end.to change(Definition, :count).by(2)
      end

      page.should have_content "Word was successfully created."

      word = Word.find_by_text("hysteria")
      word.should_not be_nil
      word.definitions[0].text.should == "Behavior exhibiting excessive or uncontrollable emotion, such as fear or panic."

      word.definitions[1].text.should == "A mental disorder characterized by emotional excitability and sometimes by amnesia or a physical deficit, such as paralysis, or a sensory deficit, without an organic cause."
    end

    it "re-renders the form with an error if wordnik does not have the word" do
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

      page.should have_link "Edit", href: edit_word_definition_path(word, definition_1)
      page.should have_link "Edit", href: edit_word_definition_path(word, definition_2)

      page.should have_link "Delete", href: word_definition_path(word, definition_1)
      page.should have_link "Delete", href: word_definition_path(word, definition_2)
    end
  end
end
