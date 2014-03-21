class Definition < ActiveRecord::Base
  belongs_to :word
  validates_presence_of :word_id

  def serializable_hash(options={})
    options ||= {}
    super(options.merge(:except => [:updated_at, :created_at, :id, :example, :word_id]))
  end
end
