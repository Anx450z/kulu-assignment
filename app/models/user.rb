class User < ApplicationRecord
  has_many :tokens, dependent: :destroy
  has_and_belongs_to_many :projects, join_table: :projects_users
  has_many :owned_projects, class_name: "Project", foreign_key: "owner_id"
  has_many :invites
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :tasks, join_table: :tasks_users

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, if: :password_required?

  devise :database_authenticatable, :registerable, :omniauthable, omniauth_providers: %i[google_oauth2]

  before_save :downcase_email

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

  def downcase_email
    self.email = email.downcase
  end

  def password_required?
    new_record?
  end
end
