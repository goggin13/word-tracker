require 'rails_helper'

RSpec.describe Commands::Define, type: :model do
  describe "applicable?" do
    it "is true for 'define word'" do
      result = Commands::Define.new.applicable?("define word")
      expect(result).to be true
    end

    it "is true for 'DEFINE word'" do
      result = Commands::Define.new.applicable?("DEFINE word")
      expect(result).to be true
    end

    it "is false for 'alternate word'" do
      result = Commands::Define.new.applicable?("alternate word")
      expect(result).to be false
    end

    it "is false for 'define'" do
      result = Commands::Define.new.applicable?("define")
      expect(result).to be false
    end

    it "is false for 'define word word'" do
      result = Commands::Define.new.applicable?("define word word")
      expect(result).to be false
    end
  end

  describe "process" do
    it "creates a new word with definitions, and sends a text with the response" do
      expected_response = [
        "hysteria",
        "- Behavior exhibiting excessive or uncontrollable emotion, such as fear or panic.",
        "- A mental disorder characterized by emotional excitability and sometimes by amnesia or a physical deficit, such as paralysis, or a sensory deficit, without an organic cause."
      ].join("\n")

      expect(TwilioClient).to receive(:text).with(expected_response)

      VCR.use_cassette "hysteria_api_response" do
        Commands::Define.new.process("define hysteria")
      end

      word = Word.find_by_text("hysteria")
      word.should_not be_nil
      word.definitions[0].text.should == "Behavior exhibiting excessive or uncontrollable emotion, such as fear or panic."

      word.definitions[1].text.should == "A mental disorder characterized by emotional excitability and sometimes by amnesia or a physical deficit, such as paralysis, or a sensory deficit, without an organic cause."
    end

    it "responds with not found if no word is found" do
      expected_response = "no definitions found for 'this-word-wont-be-found'"
      expect(TwilioClient).to receive(:text).with(expected_response)

      VCR.use_cassette "not_found_api_response" do
        Commands::Define.new.process("define this-word-wont-be-found")
      end
    end
  end
end
