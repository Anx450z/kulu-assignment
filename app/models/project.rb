class Project < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :projects_users
  has_many :invites
  belongs_to :owner, class_name: "User"

  validates :title, presence: true

  def owner?(current_user)
    owner == current_user
  end
end
