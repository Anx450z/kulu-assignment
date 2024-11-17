puts "Creating users..."
users = [
  { email: 'john@example.com', password: 'password123' },
  { email: 'jane@example.com', password: 'password123' },
  { email: 'bob@example.com', password: 'password123' },
  { email: 'alice@example.com', password: 'password123' },
  { email: 'charlie@example.com', password: 'password123' }
].map do |user_attrs|
  User.create!(user_attrs)
end

puts "Created #{users.count} users"

puts "Creating projects..."
projects = [
  { title: 'Web Application', description: 'Building a new web application', owner: users.sample },
  { title: 'Mobile App', description: 'iOS and Android development', owner: users.sample },
  { title: 'Database Migration', description: 'Migrating legacy database', owner: users.sample }
].map do |project_attrs|
  project = Project.create!(project_attrs)
  project
end

puts "Created #{projects.count} projects"


puts "Creating invites..."
invites = []

projects.each do |project|
  owner = User.find(project.owner.id)

  other_users = users - [ owner ]

  other_users.each do |invitee|
    user = other_users.sample
    other_users -= [ user ]

    invites << Invite.create!(
      project: project,
      user: user,
      role: [ :member, :admin ].sample,
      status: [ :pending, :accepted ].sample,
      email: invitee.email
    )
  end
end

puts "Created #{invites.count} invites"

puts "\nSeeding completed!"
puts "Summary:"
puts "- Users: #{User.count}"
puts "- Projects: #{Project.count}"
puts "- Invites: #{Invite.count}"
puts "\nSample user credentials:"
puts "Email: john@example.com"
puts "Password: password123"
