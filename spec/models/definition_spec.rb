require 'spec_helper'

describe Definition do
  it "creates a new definition" do
    definition = Definition.create!  word: "test", text: "test-definition", example: "test-example"

    definition.word.should == "test"
    definition.text.should == "test-definition"
    definition.example.should == "test-example"
  end

  describe "as_json" do
    it "includes only word, text" do
      definition = Definition.create!  word: "test", text: "test-definition", example: "test-example"
      definition.as_json.should == {"word" => "test", "text" =>"test-definition"}
    end
  end

  describe "self.find_or_create_for_word" do
    it "returns existing definitions if they exist" do
      FactoryGirl.create(:definition, word: "my-word", text: "my-definition-1")
      FactoryGirl.create(:definition, word: "my-word", text: "my-definition-2")

      definitions = Definition.find_or_create_for_word("my-word")

      definitions[0].word.should == "my-word"
      definitions[0].text.should == "my-definition-1"
      definitions[1].word.should == "my-word"
      definitions[1].text.should == "my-definition-2"
    end

    it "creates a definition for each result wordnik returns" do
      VCR.use_cassette "hysteria_api_response" do
        expect do
          definitions = Definition.find_or_create_for_word("hysteria")

          definitions[0].text.should == "Behavior exhibiting excessive or uncontrollable emotion, such as fear or panic."
          definitions[1].text.should == "A mental disorder characterized by emotional excitability and sometimes by amnesia or a physical deficit, such as paralysis, or a sensory deficit, without an organic cause."
        end.to change(Definition, :count).by(2)
      end
    end

    it "does not requery wordnik" do
      VCR.use_cassette "hysteria_api_response" do
         Definition.find_or_create_for_word("hysteria")
      end

      expect { Definition.find_or_create_for_word("hysteria") }.to change(Definition, :count).by(0)
    end
  end
end
