class Task < ApplicationRecord
  belongs_to :project
  has_and_belongs_to_many :users, join_table: :tasks_users

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }, allow_nil: true

  belongs_to :project, touch: true

  scope :active, -> { where(completed_at: nil) }
  scope :completed, -> { where.not(completed_at: nil) }

  after_save :ensure_unique_project_user_combination

  private

  def ensure_unique_project_user_combination
    users.each do |user|
      existing_tasks = Task.joins(:users)
                          .where(project_id: project_id, users: { id: user.id })
                          .where.not(id: id)

      if existing_tasks.exists?
        errors.add(:base, "User #{user.id} already has a task in this project")
        raise ActiveRecord::RecordInvalid.new(self)
      end
    end
  end
end
