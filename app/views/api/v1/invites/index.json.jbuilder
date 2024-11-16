json.invites @invites do |invite|
  json.partial! "api/v1/invites/invite", invite: invite
end
