module BaseModel
  extend ActiveSupport::Concern

  included do
    class << self
      def table_name_prefix
        "m_" if name.first(3) == "M::"
      end
    end

    private
    def secured_gen_str attr
      str = ""
      loop do
        str = SecureRandom.urlsafe_base64 Settings.try(self.class.name.underscore.pluralize).try(attr).secure_length
        try attr.to_s + "=", str
        break unless attr =~ /\W/ || self.class.exists?(attr => str)
      end
      str
    end
  end
end
