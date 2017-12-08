class TwilioClient
  def self.text(message)
    result = TWILIO_CLIENT.messages.create(
      from: TWILIO_FROM_NUMBER,
      to: TWILIO_TO_NUMBER,
      body: message
    )

    message = "Sent text to #{TWILIO_TO_NUMBER}"
    Rails.logger.info(message)

    result
  end
end
