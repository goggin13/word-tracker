module Commands
  ALL = [
    DEFINE = Define.new,
    QUOTE = Quote.new,
  ]

  class Handler
    def self.help
      commands = ALL.map { |c| "- #{c.help}" }
      (["Here are the commands I respond to:"] + commands).join("\n")
    end

    def self.handle(text)
      command = ALL.detect { |command| command.applicable?(text) }

      if command.nil?
        TwilioClient.text(help)
        false
      else
        command.process(text)
        true
      end
    end
  end
end
