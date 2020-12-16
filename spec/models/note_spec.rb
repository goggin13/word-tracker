require 'rails_helper'

RSpec.describe Note, type: :model do
  describe "random_for" do
    it "returns notes for a user" do
      user = FactoryBot.create(:user)
      notes = (0..1).map do
        Note.create!(
          :user => user,
          :front => "f",
          :back => "b",
        )
      end

      random = Note.random_for(user, 1)
      expect(random.length).to eq(1)
      expect(notes).to include(random[0])
    end

    it "only includes notes from the user" do
      user = FactoryBot.create(:user)
      FactoryBot.create(:note)

      random = Note.random_for(user, 1)
      expect(random.length).to eq(0)
    end
  end
end
