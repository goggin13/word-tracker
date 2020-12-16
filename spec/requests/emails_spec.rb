require "spec_helper"

describe "emails", :type => :request do
  describe "GET new" do
    it "displays notes from quotes" do
      user = FactoryBot.create(:user)
      FactoryBot.create(:word, :user => user)
      note = FactoryBot.create(
        :note,
        :user => user,
        :front => "front",
        :back => "back",
        :tags => [Tag::QUOTE]
      )

      expect(Note).to receive(:random_for).and_return([note])
      visit new_email_path(:user_id => user.id)

      expect(page).to have_content("front")
      expect(page).to have_content("back")
    end

    it "displays a word of the day" do
      user = FactoryBot.create(:user)
      word = FactoryBot.create(:word, :user => user, :text => "hello world")

      visit new_email_path(:user_id => user.id)

      expect(page).to have_link("hello world", word_url(word))
    end
  end
end
