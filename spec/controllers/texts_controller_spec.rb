require "rails_helper"

RSpec.describe TextsController, type: :controller do
  describe "POST /create" do
    describe "define" do
      it "creates a new word and definition and replies with that" do
        expected_response = [
          "hysteria",
          "- Behavior exhibiting excessive or uncontrollable emotion, such as fear or panic.",
          "- A mental disorder characterized by emotional excitability and sometimes by amnesia or a physical deficit, such as paralysis, or a sensory deficit, without an organic cause."
        ].join("\n")

        expect(TwilioClient).to receive(:text).with(expected_response)

        VCR.use_cassette "hysteria_api_response" do
          post :create, :Body => "Define hysteria"
          expect(response).to be_success
        end

        word = Word.find_by_text("hysteria")
        word.should_not be_nil
        word.definitions[0].text.should == "Behavior exhibiting excessive or uncontrollable emotion, such as fear or panic."

        word.definitions[1].text.should == "A mental disorder characterized by emotional excitability and sometimes by amnesia or a physical deficit, such as paralysis, or a sensory deficit, without an organic cause."
      end
    end

    describe "unknown" do
      it "texts the help" do
        expected_response = Commands::Handler.help
        expect(TwilioClient).to receive(:text).with(expected_response)
        post :create, :Body => "unknown"
      end
    end
  end
end
