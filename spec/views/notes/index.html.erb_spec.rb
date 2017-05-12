require 'rails_helper'

RSpec.describe "notes/index", type: :view do
  before(:each) do
    assign(:notes, [
      Note.create!(
        :user_id => 2,
        :front => "MyTextFront",
        :back => "MyTextBack"
      ),
      Note.create!(
        :user_id => 2,
        :front => "MyTextFront",
        :back => "MyTextBack"
      )
    ])
  end

  it "renders a list of notes" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "MyTextFront".to_s, :count => 2
    assert_select "tr>td", :text => "MyTextBack".to_s, :count => 2
  end
end
