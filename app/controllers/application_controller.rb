class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :set_most_recent

  def heartbeat
    r = ActiveRecord::Base.connection.execute("select 1 as one")
    render text: "OK", status: (r[0]["one"] == "1" ? 200 : 500)
  end

  def set_most_recent
    @most_recent = Definition.order("created_at DESC").limit(10)
  end
end
