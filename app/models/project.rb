class Project < ApplicationRecord
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  has_many :invites
  belongs_to :owner, class_name: "User"

  validates :title, presence: true

  def owner?(current_user)
    owner == current_user
  end
end
