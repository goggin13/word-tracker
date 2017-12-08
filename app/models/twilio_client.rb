class TwilioClient
  def self.text(message)
    TWILIO_CLIENT.messages.create(
      from: TWILIO_FROM_NUMBER,
      to: TWILIO_TO_NUMBER,
      body: message
    )
  end
end
