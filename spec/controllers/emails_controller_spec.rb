require 'spec_helper'

describe EmailsController, :type => :controller do
  describe "POST create" do
    it "sends an email to the user" do
      user = FactoryBot.create(:user)
      result = VCR.use_cassette("send_grid_api_response") do
        post :create, params: {:user_id => user.id}
        expect(response).to be_created
      end
    end
  end
end
