json.extract! comment, :id, :body, :created_at, :updated_at, :likes
json.likes_count comment.likes.count
json.commenter comment.user, partial: "api/v1/users/user", as: :user
