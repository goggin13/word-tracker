require 'rails_helper'

RSpec.describe "notes/new", type: :view do
  before(:each) do
    assign(:note, Note.new(
      :user_id => 1,
      :front => "MyText",
      :back => "MyText"
    ))
  end

  it "renders new note form" do
    render

    assert_select "form[action=?][method=?]", notes_path, "post" do

      assert_select "textarea#note_front[name=?]", "note[front]"

      assert_select "textarea#note_back[name=?]", "note[back]"
    end
  end
end
