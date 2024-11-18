json.extract! task,
              :id,
              :title,
              :description,
              :completed_at,
              :due_date,
              :created_at,
              :updated_at

json.users task.users do |user|
  json.partial! 'api/v1/users/user', user: user
end

json.completed !task.completed_at.nil?
json.overdue task.due_date && task.due_date < Time.current && task.completed_at.nil?
