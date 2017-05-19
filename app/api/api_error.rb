module APIError
  class Base < Grape::Exceptions::Base
    def initialize *args
      if args.length == 0
        t_key = self.class.name.underscore.gsub(%r{\/}, ".")
        super message: I18n.t(t_key)
      else
        super(*args)
      end
    end
  end

  class Unauthenticated < APIError::Base
  end

  class Unauthorized < APIError::Base
  end

  class TokenExpired < APIError::Base
  end
end
