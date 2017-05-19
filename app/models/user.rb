class User < ApplicationRecord
  has_many :user_tokens

  validates :user_name, length: {maximum: Settings.validations.user.user_name.max_length}, presence: true
  validates :email, presence: true, uniqueness: true,
    format: {with: Regexp.new(Settings.validations.email_regex, Regexp::IGNORECASE)},
    length: {maximum: Settings.validations.strings.max_length}
  validates :password_digest, presence: true
  validate :check_same_password, on: :update, if: :password_digest_changed?

  has_secure_password

  def check_same_password
    return unless BCrypt::Password.new(password_digest_was) == password
    errors.add(:password, I18n.t("validations.message_errors.password_same"))
  end

  class << self
    def from_access_token token
      user_token = UserToken.find_by token: token
      return unless user_token
      raise APIError::TokenExpired if user_token.expired?
      user_token.user
    end
  end

  def req_reset_passwd!
    update_attributes! reset_pwd_token: secured_gen_str(:reset_pwd_token),
      reset_pwd_expired_at: Time.zone.now + instance_eval(Settings.users.reset_pwd_token.expired_period)
  end

  def reset_pwd_expired?
    reset_pwd_expired_at <= Time.zone.now
  end
end
