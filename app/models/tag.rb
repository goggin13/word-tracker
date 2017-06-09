class Tag < ActiveRecord::Base
  has_and_belongs_to_many :notes

  def random_notes(n=1)
    notes.limit(n).order("RANDOM()")
  end
end
