require 'rails_helper'

RSpec.describe "notes/edit", type: :view do
  before(:each) do
    @note = assign(:note, Note.create!(
      :user_id => 1,
      :front => "MyText",
      :back => "MyText"
    ))
  end

  it "renders the edit note form" do
    render

    assert_select "form[action=?][method=?]", note_path(@note), "post" do

      assert_select "textarea#note_front[name=?]", "note[front]"

      assert_select "textarea#note_back[name=?]", "note[back]"
    end
  end
end
