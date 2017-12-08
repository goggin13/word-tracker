module Commands
  class Define
    def help
      "define <word>"
    end

    def applicable?(text)
      result = text =~ /^define \w+\s*$/i

      !result.nil? && result >= 0
    end

    def process(text)
      word_string = text.downcase.split(" ")[1]
      word = Word.find_or_create_with_definitions(
        User.find_or_create_default_user,
        word_string,
      )

      if word.nil?
        _send_not_found(word_string)
      else
        _send_definitions(word)
      end
    end

    def _send_not_found(word_string)
      TwilioClient.text("no definitions found for '#{word_string}'")
    end

    def _send_definitions(word)
      definitions = word.definitions.map { |d| "- #{d.text}" }
      response = ([word.text] + definitions).join("\n")
      TwilioClient.text(response)
    end
  end
end
