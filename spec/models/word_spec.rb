require 'spec_helper'

describe Word do

  describe "definitions" do
    it "is destroyed with the word" do
      definition = FactoryGirl.create(:definition, text: "my-definition-1")
      definition.word.destroy

      Definition.find_by_id(definition.id).should be_nil
    end
  end

  describe "self.find_or_create_with_definitions" do
    it "returns existing definitions if they exist" do
      word = FactoryGirl.create(:word, text: "my-word")
      FactoryGirl.create(:definition, word: word, text: "my-definition-1")
      FactoryGirl.create(:definition, word: word, text: "my-definition-2")

      returned_word = Word.find_or_create_with_definitions("my-word")

      returned_word.id.should == word.id
      returned_word.definitions[0].text.should == "my-definition-1"
      returned_word.definitions[1].text.should == "my-definition-2"
    end

    it "creates a definition for each result wordnik returns" do
      VCR.use_cassette "hysteria_api_response" do
        expect do
          expect do
            word = Word.find_or_create_with_definitions("hysteria")
            definitions = word.definitions

            definitions[0].text.should == "Behavior exhibiting excessive or uncontrollable emotion, such as fear or panic."
            definitions[1].text.should == "A mental disorder characterized by emotional excitability and sometimes by amnesia or a physical deficit, such as paralysis, or a sensory deficit, without an organic cause."
          end.to change(Definition, :count).by(2)
        end.to change(Word, :count).by(1)
      end
    end

    it "does not requery wordnik nor create new entries if the word exists" do
      VCR.use_cassette "hysteria_api_response" do
        Word.find_or_create_with_definitions("hysteria")
      end

      expect do
        Word.find_or_create_with_definitions("hysteria")
      end.to change(Definition, :count).by(0)
    end

    it "returns nil if there is no definition found in wordnik" do
      VCR.use_cassette "not_found_api_response" do
        Word.find_or_create_with_definitions("this-word-wont-be-found").should be_nil
      end
    end
  end

  describe "to_json" do
    it "includes definitions nested" do
      word = FactoryGirl.create(:word, text: "my-word")
      FactoryGirl.create(:definition, word: word, text: "my-definition-1")
      FactoryGirl.create(:definition, word: word, text: "my-definition-2")

      word.as_json.should == {
        "my-word" => ["my-definition-1", "my-definition-2"]
      }
    end
  end
end
