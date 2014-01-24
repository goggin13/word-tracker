class Definition < ActiveRecord::Base

  def self.find_or_create_for_word(word)
    existing = Definition.where(word: word)
    return existing unless existing.empty?

    Wordnik.word.get_definitions(word).map do |wordnik_definition|
      Definition.create! word: word, text: wordnik_definition["text"]
    end
  end

  def serializable_hash(options={})
    options ||= {}
    super(options.merge(:except => [:updated_at, :created_at, :id, :example]))
  end
end
