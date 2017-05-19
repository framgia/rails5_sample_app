module BaseAPI
  extend ActiveSupport::Concern

  included do
    prefix "api"
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers
    error_formatter :json, ErrorFormatter
    default_format :json

    rescue_from Grape::Exceptions::ValidationErrors do
      error!({error_code: Settings.error_formatter.error_codes.validation_errors,
              message: I18n.t("api_error.validation_errors")},
        Settings.http_code.code_200)
    end

    rescue_from APIError::Base do |e|
      error_code = Settings.error_formatter.error_codes.public_send(
        e.class.name.split("::").drop(1).map(&:underscore).first)
      error!({error_code: error_code, message: e.message}, Settings.http_code.code_200)
    end

    rescue_from ActiveRecord::UnknownAttributeError, ActiveRecord::RecordInvalid, ActiveRecord::StatementInvalid,
      JSON::ParserError do |e|
      error!({error_code: Settings.error_formatter.error_codes.data_operation, message: e.message},
        Settings.http_code.code_200)
    end

    rescue_from ActiveRecord::RecordNotFound do
      error!({error_code: Settings.error_formatter.error_codes.record_not_found,
              message: I18n.t("api_error.record_not_found")},
        Settings.http_code.code_200)
    end

    helpers do
      def authenticate!
        raise APIError::Unauthenticated unless current_user
      end

      def current_user
        @current_user ||= User.from_access_token access_token_header
      end

      def access_token_header
        headers[Settings.access_token_header]
      end

      def pagination_dict object
        {
          current_page: object.current_page,
          next_page: object.next_page,
          prev_page: object.prev_page,
          total_pages: object.total_pages,
          total_count: object.total_count
        }
      end
    end
  end
end
