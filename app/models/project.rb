class Project < ApplicationRecord
  has_many :invites, dependent: :destroy
  has_many :users, through: :invites
  validates :title, presence: true
end
