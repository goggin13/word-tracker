require 'rails_helper'

RSpec.describe SendGrid, type: :model do
  describe "send_mail" do
    it "sends a request to the send grid api" do
      result = VCR.use_cassette("send_grid_api_response") do
        SendGrid.send_mail(
          "goggin13@gmail.com",
          "TEST",
          "<h1>hello world</h1>",
        )
      end

      expect(result).to eq(true)
    end
  end

  describe "send_daily_email" do
  end
end
