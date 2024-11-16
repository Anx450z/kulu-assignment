json.partial! "api/v1/projects/project", project: @project

json.members @members do |invite|
  json.partial! "api/v1/invites/invite", invite: invite
end

json.pending_invites @pending_invites do |invite|
  json.partial! "api/v1/invites/invite", invite: invite
end
