class EmailsController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false
  before_filter :_setup

  def new
  end

  def create
    html = render_to_string(
      :template => "emails/new",
      :layout => false,
    )

    subject_date = Time.now
      .in_time_zone("America/Chicago")
      .strftime("%B %d")

    result = SendGrid.send_mail(
      @user.email,
      "Good Morning - #{subject_date}",
      html
    )

    Rails.logger.info "Sent email to #{@user.email}, result: #{result}"

    if result
      render :text => "Sent at #{Time.now}\n", :status => :created
    else
      render :text => "Failed at #{Time.now}\n"
    end
  end

  def _setup
    @user = User.find(params[:user_id])
    @notes = Note.random_for(@user, 2)
    @word = @user.random_word
    @tags = [Tag::QUOTE]
  end
end
