json.extract! project, :id, :title, :description, :created_at, :updated_at

json.member_count project.invites.accepted.count
json.owner project.owner, partial: "api/v1/users/user", as: :user

json.current_user_role project.invites.find_by(user: current_user)&.role
