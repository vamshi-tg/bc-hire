# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Candidates
50.times do |n|
    name = Faker::Name.name
    email = "example-#{n}@gmail.com"
    Candidate.create!(
        name: name,
        email: email)  
end

# Employee
roles = ["manager", "interviewer"]
5.times do |n|
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = "#{first_name}.#{last_name}@example.com"
    role = n % 2 == 0 ? roles[0] : roles[1] 
    provider = "google_oauth2"
    uid = Faker::Number.number(10)
    Employee.create!(first_name: first_name, last_name: last_name, email: email, role: role, provider: provider, uid: uid)
end

# Candidates Application
candidates = Candidate.order(:created_at).take(30)
manager = Employee.find_by(role: "manager")
roles = ["Full Stack Developer", "Web Developer", "Graphic Designer"]
candidates.each do|candidate| 
    role = roles[rand 0..2]
    experience = rand 1..10
    owner_id = manager.id
    candidate.applications.create!(role: role, experience: experience, owner_id: owner_id)
end

