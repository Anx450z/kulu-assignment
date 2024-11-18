json.task do
  json.partial! 'task', task: @task
end

json.project @task.project, partial: "api/v1/projects/project", as: :project
