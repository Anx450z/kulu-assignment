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
  { title: 'Web Application', description: 'Building a new web application' },
  { title: 'Mobile App', description: 'iOS and Android development' },
  { title: 'Database Migration', description: 'Migrating legacy database' }
].map do |project_attrs|
  project = Project.create!(project_attrs)
  Invite.create!(
    project: project,
    user: users.sample,
    role: :owner,
    status: :accepted
  )
  project
end

puts "Created #{projects.count} projects"


puts "Creating invites..."
invites = []

projects.each do |project|
  owner = project.invites.find_by(role: :owner).user

  other_users = users - [ owner ]

  2.times do
    user = other_users.sample
    other_users -= [ user ]

    invites << Invite.create!(
      project: project,
      user: user,
      role: [ :member, :admin ].sample,
      status: :accepted
    )
  end

  2.times do
    user = other_users.sample
    other_users -= [ user ]

    next unless user

    invites << Invite.create!(
      project: project,
      user: user,
      role: :member,
      status: :pending
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
