class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :json_request?
  before_filter :set_most_recent

  def heartbeat
    r = ActiveRecord::Base.connection.execute("select 1 as one")
    render text: "OK", status: (r[0]["one"] == "1" ? 200 : 500)
  end

  def set_most_recent
    @most_recent = Word.order("created_at DESC").limit(10)
  end

  def json_request?
    request.format.json?
  end

  def authenticate!
    unless user_signed_in?
      respond_to do |format|
        format.html {
          flash[:warning] = "You must be logged in."
          redirect_to root_path
        }
        format.json { render json: {}, status: 401 }
      end
    end
  end
end
