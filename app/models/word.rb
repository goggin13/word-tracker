class Word < ApplicationRecord
  has_many :definitions, dependent: :destroy
  belongs_to :user
  validates_presence_of :user_id

  def first_definition
    definitions.length > 0 ? definitions.first.text : ""
  end

  def serializable_hash(options={})
    { text => definitions.map(&:text) }
  end

  def self.find_or_create_with_definitions(user, text)
    existing = Word.where(text: text, user: user).first
    return existing if existing

    definitions = Wordnik.word.get_definitions(text).map { |r| r["text"] }
    return nil if definitions.length == 0

    word = Word.create! text: text, user: user
    definitions.each { |d| word.definitions.create! text: d }

    word
  end
end
