class Task < ApplicationRecord
  belongs_to :project
  has_and_belongs_to_many :users, join_table: :tasks_users
  belongs_to :project, touch: true
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }, allow_nil: true

  scope :active, -> { where(completed_at: nil) }
  scope :completed, -> { where.not(completed_at: nil) }

  # validate :unique_task_user_combination

  private

  def unique_task_user_combination
    # Ensure no duplicate user-task assignments
    duplicate_users = users.group_by(&:id).select { |_, group| group.size > 1 }.keys
    if duplicate_users.any?
      errors.add(:users, "cannot have duplicates for the same task")
    end
  end
end
