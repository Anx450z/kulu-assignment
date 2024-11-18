class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  default_scope { order(created_at: :desc) }

  def update_likes(user)
    if likes.include?(user.id)
      likes.delete(user.id)
    else
      likes << user.id
    end
    save
  end
end
