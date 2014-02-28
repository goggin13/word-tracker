require 'spec_helper'

describe "Definitions", type: "request" do
  describe "GET /definitions" do
    it "returns a JSON array with all the existing words" do
      FactoryGirl.create(:definition, :word => "word1")
      FactoryGirl.create(:definition, :word => "word2")

      get definitions_path(format: "json")

      response.status.should == 200
      result = JSON.parse(response.body)

      result[0]["word"].should == "word1"
      result[1]["word"].should == "word2"
    end

    it "renders an HTML page with all of the words" do
      definition = FactoryGirl.create(:definition, word: "hysteria", text: "definition a")

      visit definitions_path(format: "html")

      page.should have_content "hysteria"
      page.should have_content "definition a"
      page.should have_link "Edit", href: edit_definition_path(definition)
      page.should have_link "hysteria", href: definition_path(definition)
    end
  end

  describe "POST /define.json" do
    it "returns existing definitions if they are available" do
      FactoryGirl.create(:definition, word: "hysteria", text: "definition a")
      FactoryGirl.create(:definition, word: "hysteria", text: "definition b")

      get define_path, :word => "hysteria"

      response.status.should == 200
      result = JSON.parse(response.body)

      result["word"].should == "hysteria"
      result["definitions"][0].should == "definition a"
      result["definitions"][1].should == "definition b"
    end

    it "looks up the defintion from wordnik" do
      VCR.use_cassette "hysteria_api_response" do
        get define_path, :word => "hysteria"
        response.status.should == 200
        result = JSON.parse(response.body)

        result["word"].should == "hysteria"
        result["definitions"][0].should == "Behavior exhibiting excessive or uncontrollable emotion, such as fear or panic."
        result["definitions"][1].should == "A mental disorder characterized by emotional excitability and sometimes by amnesia or a physical deficit, such as paralysis, or a sensory deficit, without an organic cause."
      end
    end
  end

  describe "new definitions" do
    it "does not have form fields for example, or text" do
      visit new_definition_path

      page.should_not have_field "Text"
      page.should_not have_field "Example"
    end

    it "creates a new definition from the wordnik api" do
      visit new_definition_path

      VCR.use_cassette "hysteria_api_response" do
        fill_in "Word", with: "hysteria"

        expect do
          click_button "Create Definition"
        end.to change(Definition, :count).by(2)
      end

      page.should have_content "Definition was successfully created."

      def1 = Definition.all[0]
      def2 = Definition.all[1]

      def1.word.should == "hysteria"
      def1.text.should == "Behavior exhibiting excessive or uncontrollable emotion, such as fear or panic."

      def2.word.should == "hysteria"
      def2.text.should == "A mental disorder characterized by emotional excitability and sometimes by amnesia or a physical deficit, such as paralysis, or a sensory deficit, without an organic cause."
    end
  end

  describe "new definitions" do
    it "has form fields for example and text" do
      visit edit_definition_path(FactoryGirl.create(:definition))

      page.should have_field "Text"
      page.should have_field "Example"
    end
  end
end
