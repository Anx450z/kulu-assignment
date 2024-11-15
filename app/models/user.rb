class User < ApplicationRecord
  has_many :tokens, dependent: :destroy
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  devise :database_authenticatable, :registerable, :omniauthable, omniauth_providers: %i[google_oauth2]

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data["email"]).first

    unless user
        user = User.create(
           email: data["email"],
           password: Devise.friendly_token[0, 20]
        )
    end
    user
  end
end
