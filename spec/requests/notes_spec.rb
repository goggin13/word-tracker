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

  describe "POST /notes" do
    before do
      @user = FactoryGirl.create(:user)
      integration_login @user

      visit new_note_path
    end

    it "creates a note" do
      fill_in "Front", with: "front"
      fill_in "Back", with: "back"

      expect do
        click_button "Create Note"
      end.to change(Note, :count).by(1)

      note = Note.last
      expect(note.front).to eq("front")
      expect(note.back).to eq("back")
      expect(note.user.id).to eq(@user.id)
    end

    it "creates a note with tags" do
      fill_in "Front", with: "front"
      fill_in "Back", with: "back"
      fill_in "Tags", with: "hello world"

      click_button "Create Note"

      note = Note.last
      expect(note.tags.count).to eq(2)

      tag_names = note.tags.map(&:name)
      expect(tag_names).to include("hello")
      expect(tag_names).to include("world")
    end
  end

  describe "updating a note" do
    it "updates tags" do
      integration_login FactoryGirl.create(:user)
      visit new_note_path

      fill_in "Front", with: "front"
      fill_in "Back", with: "back"
      fill_in "Tags", with: "hello world"

      click_button "Create Note"
      expect(Tag.where(name: "hello").first).to_not be_nil

      note = Note.last

      visit edit_note_path(note)

      page.should have_field "Tags", with: "hello world"
      fill_in "Tags", with: "goodbye world"

      click_button "Update Note"

      note.reload
      expect(note.tags.count).to eq(2)

      tag_names = note.tags.map(&:name)
      expect(tag_names).to_not include("hello")
      expect(tag_names).to include("goodbye")
      expect(tag_names).to include("world")

      expect(Tag.where(name: "hello").first).to_not be_nil
    end
  end
end
