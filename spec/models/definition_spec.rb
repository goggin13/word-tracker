require 'spec_helper'

describe Definition do
  before do
    @word = FactoryGirl.create(:word)
  end

  it "creates a new definition" do
    definition = Definition.create! word: @word, text: "test-definition", example: "test-example"

    definition.text.should == "test-definition"
    definition.example.should == "test-example"
  end

  describe "as_json" do
    it "includes only text" do
      definition = Definition.create! word: @word, text: "test-definition", example: "test-example"
      definition.as_json.should == {"text" =>"test-definition"}
    end
  end
end
