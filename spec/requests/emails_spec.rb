require "spec_helper"

describe "emails", :type => :request do
  describe "GET new" do
    it "displays notes from categories" do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:word, :user => user)
      notes = (0..1).map do |i|
        FactoryGirl.create(
          :note,
          :user => user,
          :front => "front - #{i}",
          :back => "back - #{i}",
        )
      end

      notes[0].tags.create! :name => "medical"
      notes[1].tags.create! :name => "military"

      expect(Note).to receive(:random_for).and_return(notes)
      visit new_email_path(:user_id => user.id)

      expect(page).to have_content("front - 0")
      expect(page).to have_link("View", note_url(notes[0]))
      expect(page).to have_content("front - 1")
      expect(page).to have_link("View", note_url(notes[1]))
    end

    it "displays a word of the day" do
      user = FactoryGirl.create(:user)
      word = FactoryGirl.create(:word, :user => user, :text => "hello world")

      visit new_email_path(:user_id => user.id)

      expect(page).to have_link("hello world", word_url(word))
    end
  end
end
