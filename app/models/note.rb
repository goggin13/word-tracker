class Note < ActiveRecord::Base
  validates_presence_of :front
  validates_presence_of :back
  validates_presence_of :user_id

  belongs_to :user

  def self.random_for(user, n)
    Note
      .where(:user => user)
      .limit(n)
      .order("RANDOM()")
  end

  def back_rendered
    _render(back)
  end

  def front_rendered
    _render(front)
  end

  def _render(markdown)
    Kramdown::Document.new(markdown).to_html.html_safe
  end
end
