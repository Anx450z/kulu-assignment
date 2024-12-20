class Project < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :projects_users
  has_many :invites, dependent: :destroy
  belongs_to :owner, class_name: "User"
  has_many :tasks

  validates :title, presence: true

  def owner?(current_user)
    owner == current_user
  end
end
