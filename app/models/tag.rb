class Tag < ApplicationRecord
  QUOTE = Tag.find_or_create_by(name: "quotes")

  has_and_belongs_to_many :notes

  def random_notes(n=1)
    notes.limit(n).order("RANDOM()")
  end
end
