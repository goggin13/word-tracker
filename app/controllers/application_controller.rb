class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :json_request?
  rescue_from User::NoDefaultUserDefined, with: :no_default_user

  def heartbeat
    r = ActiveRecord::Base.connection.execute("select 1 as one")
    render plain: "OK", status: (r[0]["one"].to_s == "1" ? 200 : 500)
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

  def no_default_user
    flash[:error] = "No default user is setup."
    redirect_to new_user_registration_path
  end
end
