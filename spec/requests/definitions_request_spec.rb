require 'spec_helper'

describe "Definitions", type: "request" do
  describe "GET /definitions" do
    it "returns a JSON array with all the existing words" do
      FactoryGirl.create(:definition, :word => "word1")
      FactoryGirl.create(:definition, :word => "word2")

      get definitions_path

      response.status.should == 200
      result = JSON.parse(response.body)

      result[0]["word"].should == "word1"
      result[1]["word"].should == "word2"
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
end
