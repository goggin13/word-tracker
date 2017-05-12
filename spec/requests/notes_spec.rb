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
        :front => "# Hello World",
        :back => "**hello world**",
      })

      get notes_path(note)
      expect(response).to be_success

      expect(page).to have_selector("h1", :text => "Hello World")
      expect(page).to have_selector("b", :text => "hello world")
    end
  end
end
