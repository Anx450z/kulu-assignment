class Invite < ApplicationRecord
  belongs_to :project
  belongs_to :user

  enum status: { pending: 0, accepted: 1, declined: 2 }
  enum role: { member: 0, admin: 1, owner: 2 }

  validates :status, presence: true
  validates :role, presence: true
  validates :user_id, uniqueness: { scope: :project_id, message: "is already invited to this project" }

  def admin_or_owner?
    %w[admin owner].include?(role)
  end

  def pending?
    status == "pending"
  end
end
