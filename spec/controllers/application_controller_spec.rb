require 'spec_helper'

describe ApplicationController do
  describe "heartbeat" do
    it "returns 200" do
      get :heartbeat
      response.status.should == 200
      response.body.should == "OK"
    end
  end
end
