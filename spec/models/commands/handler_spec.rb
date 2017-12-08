require 'rails_helper'

RSpec.describe Commands::Handler, type: :model do
  it "returns true and passes a command to the appropriate handler" do
    expect(Commands::DEFINE).to receive("process").with("define word")
    result = Commands::Handler.handle("define word")
    expect(result).to be true
  end

  it "returns false and texts the help if it does not have a handler" do
    expected_response = "Here are the commands I respond to:\n- define <word>"
    expect(TwilioClient).to receive(:text).with(expected_response)
    result = Commands::Handler.handle("gibberish")
    expect(result).to be false
  end
end
