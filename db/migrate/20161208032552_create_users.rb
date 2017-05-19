class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string     :user_name,        null: false
      t.string     :email,            null: false
      t.string     :password_digest,  null: false
      t.string     :reset_pwd_token
      t.datetime   :reset_pwd_expired_at

      t.timestamps
    end
  end
end
