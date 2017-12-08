module Commands
  class Quote
    def help
      'quote <quote>\n<author>'
    end

    def applicable?(text)
      result = text =~ /^quote \w+.*\n\w+/i

      !result.nil? && result >= 0
    end

    def process(text)
      lines = text.sub(/quote /i, "").split("\n")
      quote = lines[0]
      author = lines[1]

      note = Note.create(
        user: User.find_or_create_default_user,
        front: quote,
        back: author,
        tags: [Tag::QUOTE],
      )

      if note.id.present?
        TwilioClient.text("Saved quote from #{author}")
      else
        TwilioClient.text("Failed to save quote")
      end
    end
  end
end
