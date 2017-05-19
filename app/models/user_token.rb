class UserToken < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :token, presence: true, length: {maximum: Settings.validations.strings.max_length}
  validates :refresh_token, presence: true, length: {maximum: Settings.validations.strings.max_length}
  validates :expired_at, presence: true

  class << self
    def generate
      new.renew!
    end
  end

  def renew!
    update_attributes! token: secured_gen_str(:token), refresh_token: secured_gen_str(:refresh_token),
      expired_at: Time.zone.now + instance_eval(Settings.user_tokens.expired_period)
    self
  end

  def expired?
    expired_at <= Time.zone.now
  end

  def expire!
    update_attributes! expired_at: Time.zone.now
  end
end
