require 'rails_helper'

RSpec.describe "Notes", type: :request do
  describe "GET /notes" do
    it "works! (now write some real specs)" do
      get notes_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /notes/{id}" do
    it "renders the markdown on the note" do
      note = Note.create!({
        :user_id => 1,
        :front => "**Hello World**",
        :back => "**hello world**",
      })

      visit note_path(note)

      expect(page).to have_selector("strong", :text => "Hello World")
      expect(page).to have_selector("strong", :text => "hello world")
    end
  end
end
