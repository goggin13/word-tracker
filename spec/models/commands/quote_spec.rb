require 'rails_helper'

RSpec.describe Commands::Quote, type: :model do
  describe "applicable?" do
    it "is true for 'quote word\nuthor'" do
      result = Commands::Quote.new.applicable?("quote word\nauthor")
      expect(result).to be true
    end

    it "is true for 'quote word   \n  uthor  '" do
      result = Commands::Quote.new.applicable?("quote word  \n  author  ")
      expect(result).to be true
    end

    it "is false for 'quote word'" do
      result = Commands::Quote.new.applicable?("quote word")
      expect(result).to be false
    end

    it "is false for 'quote word author'" do
      result = Commands::Quote.new.applicable?("quote word author")
      expect(result).to be false
    end
  end

  describe "process" do
    it "creates a note card" do
      expected_response = "Saved quote from john milton"
      expect(TwilioClient).to receive(:text).with(expected_response)

      expect do
        Commands::Quote.new.process("quote hello world\njohn milton")
      end.to change(Note, :count).by(1)

      new_note = Note.last
      expect(new_note.front).to eq("hello world")
      expect(new_note.back).to eq("john milton")
      expect(new_note.tags.size).to eq(1)
      expect(new_note.tags[0]).to eq(Tag::QUOTE)
    end

    it "strips trailing spaces" do
      expect(TwilioClient).to receive(:text)

      expect do
        Commands::Quote.new.process("quote hello world   \njohn milton   ")
      end.to change(Note, :count).by(1)

      new_note = Note.last
      expect(new_note.front).to eq("hello world")
      expect(new_note.back).to eq("john milton")
    end

    it "handles Quote as the command" do
      expect(TwilioClient).to receive(:text)

      expect do
        Commands::Quote.new.process("Quote hello world\njohn milton")
      end.to change(Note, :count).by(1)

      new_note = Note.last
      expect(new_note.front).to eq("hello world")
    end
  end
end
