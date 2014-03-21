class Word < ActiveRecord::Base
  has_many :definitions, dependent: :destroy

  def first_definition
    definitions.length > 0 ? definitions.first.text : ""
  end

  def serializable_hash(options={})
    { text => definitions.map(&:text) }
  end

  def self.find_or_create_with_definitions(text)
    existing = Word.where(text: text).first
    return existing if existing

    definitions = Wordnik.word.get_definitions(text).map { |r| r["text"] }
    return nil if definitions.length == 0

    word = Word.create! text: text
    definitions.each { |d| word.definitions.create! text: d }

    word
  end
end
