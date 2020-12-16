class TextsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    Commands::Handler.handle(params[:Body])
    render :plain => "OK"
  end
end
