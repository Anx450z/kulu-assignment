class Project < ApplicationRecord
  has_many :users
  validates :title, presence: true

  def owner?
    owner_id == current_user.id
  end
end
