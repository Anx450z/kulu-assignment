json.extract! invite, :id, :role, :status, :created_at

json.user invite.user, partial: "api/v1/users/user", as: :user
json.project invite.project, partial: "api/v1/projects/project", as: :project
