class Invite < ApplicationRecord
  belongs_to :user
  belongs_to :project

  enum status: { pending: 0, accepted: 1 }
  enum role: { member: 0, admin: 1 }

  validates :status, presence: true
  validates :role, presence: true
  validates :email, uniqueness: { scope: :project_id, message: "is already invited to this project" }
end
