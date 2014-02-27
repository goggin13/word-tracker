class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def heartbeat
    r = ActiveRecord::Base.connection.execute("select 1 as one")
    render text: "OK", status: (r[0]["one"] == "1" ? 200 : 500)
  end
end
