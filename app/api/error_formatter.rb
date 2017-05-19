module ErrorFormatter
  def self.call message, _backtrace, _options, _env
    {
      Settings.error_formatter.error_code_key => message[Settings.error_formatter.error_code_key.to_sym],
      Settings.error_formatter.message_key => message[Settings.error_formatter.message_key.to_sym]
    }.to_json
  end
end
