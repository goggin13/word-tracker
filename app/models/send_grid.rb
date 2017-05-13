require "net/https"
require "uri"
require "json"

class SendGrid
  def self.send_mail(to, subject, content)
    uri = URI.parse("https://api.sendgrid.com/v3/mail/send")

    request = Net::HTTP::Post.new(uri,
      'Content-Type' => "application/json",
      'Authorization' => "Bearer #{ENV['SENDGRID_API_KEY']}",
    )

    request.body = _body(to, subject, content)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    response = http.request(request)

    response.code == "202"
  end

  def self._body(to, subject, body)
    {
      "personalizations": [
        {
          "to": [{"email": to}]
        },
      ],
      "from": {"email": "goggin@my-sat-words.com"},
      "subject": subject,
      "content": [
        {
          "type": "text/html",
          "value": body
        }
      ]
    }.to_json
  end

  def self.send_daily_email(user, notes)
    html = ApplicationController.new.render_to_string(
      :template => "emails/new",
      :layout => false,
      :locals => {:notes => notes}
    )

    subject_date = Time.now
      .in_time_zone("America/Chicago")
      .strftime("%B %d")

    send_mail(
      user.email,
      "Good Morning - #{subject_date}",
      html
    )
  end
end
