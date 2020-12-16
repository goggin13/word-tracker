require 'spec_helper'

describe User do
  describe "words" do
    it "is ordered by creation date" do
      user = FactoryBot.create(:user)
      FactoryBot.create(:word, :text => "c", :user => user, :created_at => Time.now.advance(:minutes => 1))
      FactoryBot.create(:word, :text => "b", :user => user, :created_at => Time.now.advance(:minutes => 2))
      FactoryBot.create(:word, :text => "a", :user => user, :created_at => Time.now.advance(:minutes => 3))

      expect(user.words[0].text).to eq("a")
      expect(user.words[1].text).to eq("b")
      expect(user.words[2].text).to eq("c")
    end
  end
end
